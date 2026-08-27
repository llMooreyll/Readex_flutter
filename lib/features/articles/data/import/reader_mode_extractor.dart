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
  final article = parse(
    html,
    parser: ParserType.jsdom,
    baseUri: baseUri,
    charThreshold: 200,
  );
  if (article == null ||
      article.title.trim().isEmpty ||
      article.textContent.trim().length < 40) {
    return null;
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
