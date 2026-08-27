import 'dart:async';
import 'dart:isolate';

import 'package:reader_mode/reader_mode.dart';
import 'package:read_it_later/core/errors/app_failure.dart';
import 'package:read_it_later/core/result/result.dart';

import 'article_extractor.dart';

final class ReaderModeExtractor implements ArticleExtractor {
  const ReaderModeExtractor();

  @override
  Future<Result<ExtractedArticle>> extract({
    required String html,
    required Uri baseUri,
  }) async {
    try {
      final pageKind = _detectPageKind(html);
      if (pageKind != null) {
        return Failure(pageKind);
      }

      final values = await Isolate.run(
        () => _parseInIsolate(html, baseUri.toString()),
      );
      if (values == null) {
        return const Failure(ArticleNotReadableFailure());
      }

      return Success(
        ExtractedArticle(
          title: values['title']!,
          content: values['content']!,
          textContent: values['textContent']!,
          excerpt: values['excerpt'],
          byline: values['byline'],
          siteName: values['siteName'],
          language: values['language'],
          publishedTime: values['publishedTime'],
        ),
      );
    } catch (error) {
      return Failure(
        UnexpectedFailure(technicalMessage: 'Reader mode: $error'),
      );
    }
  }
}

Map<String, String?>? _parseInIsolate(String html, String baseUri) {
  for (final parser in [ParserType.jsdom, ParserType.html]) {
    final article = parse(
      html,
      parser: parser,
      baseUri: baseUri,
      charThreshold: 200,
    );
    if (article == null ||
        article.title.trim().isEmpty ||
        article.textContent.trim().length < 40) {
      continue;
    }

    return <String, String?>{
      'title': article.title.trim(),
      'content': article.content,
      'textContent': article.textContent.trim(),
      'excerpt': article.excerpt?.trim(),
      'byline': article.byline?.trim(),
      'siteName': article.siteName?.trim(),
      'language': article.lang?.trim(),
      'publishedTime': article.publishedTime?.trim(),
    };
  }

  return null;
}

AppFailure? _detectPageKind(String html) {
  final lower = html.toLowerCase();
  if (lower.contains('wappoc_appmsgcaptcha') ||
      lower.contains('secitptpage/verify') ||
      lower.contains('完成验证后即可继续访问') ||
      lower.contains('当前环境异常')) {
    return const VerificationRequiredFailure();
  }

  if (lower.contains('__next_f') &&
      !lower.contains('<article') &&
      !lower.contains('article-body') &&
      !lower.contains('post-content')) {
    return const DynamicContentFailure();
  }

  return null;
}
