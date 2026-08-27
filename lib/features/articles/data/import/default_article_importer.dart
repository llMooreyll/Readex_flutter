import 'package:html/parser.dart' as html_parser;
import 'package:read_it_later/core/errors/app_failure.dart';
import 'package:read_it_later/core/result/result.dart';
import 'package:read_it_later/core/utils/reading_time.dart';
import 'package:read_it_later/features/articles/domain/article_draft.dart';
import 'package:read_it_later/features/articles/domain/article_importer.dart';

import 'article_extractor.dart';
import 'article_html_sanitizer.dart';
import 'article_source_adapter.dart';
import 'web_page_downloader.dart';

final class DefaultArticleImporter implements ArticleImporter {
  const DefaultArticleImporter({
    required this.downloader,
    required this.extractor,
    required this.sanitizer,
    this.sourceAdapters = const [],
    this.operationTimeout = const Duration(seconds: 30),
  });

  final WebPageDownloader downloader;
  final ArticleExtractor extractor;
  final ArticleHtmlSanitizer sanitizer;
  final List<ArticleSourceAdapter> sourceAdapters;
  final Duration operationTimeout;

  @override
  Future<Result<ArticleDraft>> import(Uri url) {
    return _import(url).timeout(
      operationTimeout,
      onTimeout: () => const Failure(NetworkTimeoutFailure()),
    );
  }

  Future<Result<ArticleDraft>> _import(Uri url) async {
    for (final adapter in sourceAdapters) {
      if (adapter.canHandle(url)) {
        final extracted = await adapter.extract(url);
        return _buildDraft(
          sourceUrl: url,
          resolvedUrl: url,
          extracted: extracted,
        );
      }
    }

    final downloaded = await downloader.download(url);
    if (downloaded is Failure<DownloadedPage>) {
      return Failure(downloaded.failure);
    }
    final page = (downloaded as Success<DownloadedPage>).value;
    if (page.resolvedUri.scheme.toLowerCase() != 'https' ||
        page.resolvedUri.userInfo.isNotEmpty) {
      return const Failure(InsecureRedirectFailure());
    }

    final extracted = await extractor.extract(
      html: page.html,
      baseUri: page.resolvedUri,
    );
    if (extracted is Failure<ExtractedArticle>) {
      return Failure(extracted.failure);
    }
    return _buildDraft(
      sourceUrl: url,
      resolvedUrl: page.resolvedUri,
      extracted: extracted,
      sourceHtml: page.html,
    );
  }

  Result<ArticleDraft> _buildDraft({
    required Uri sourceUrl,
    required Uri resolvedUrl,
    required Result<ExtractedArticle> extracted,
    String? sourceHtml,
  }) {
    if (extracted is Failure<ExtractedArticle>) {
      return Failure(extracted.failure);
    }
    final article = (extracted as Success<ExtractedArticle>).value;

    final sanitized = sanitizer.sanitize(
      html: article.content,
      baseUri: resolvedUrl,
    );
    if (sanitized is Failure<SanitizedArticle>) {
      return Failure(sanitized.failure);
    }
    final content = (sanitized as Success<SanitizedArticle>).value;
    final title = article.title.trim();
    if (title.isEmpty || content.text.length < 40) {
      return const Failure(ArticleNotReadableFailure());
    }

    final document = sourceHtml == null ? null : html_parser.parse(sourceHtml);
    final canonicalRaw = document
        ?.querySelector('link[rel="canonical"]')
        ?.attributes['href'];
    final canonicalUrl = canonicalRaw == null
        ? null
        : resolvedUrl.resolve(canonicalRaw).toString();

    return Success(
      ArticleDraft(
        sourceUrl: sourceUrl.toString(),
        resolvedUrl: resolvedUrl.toString(),
        canonicalUrl: canonicalUrl,
        title: title,
        excerpt: article.excerpt,
        author: article.byline,
        siteName: article.siteName,
        language: article.language,
        publishedAt: DateTime.tryParse(article.publishedTime ?? ''),
        contentHtml: content.html,
        contentText: content.text,
        estimatedReadingMinutes: estimateReadingMinutes(content.text),
        extractorVersion: 'reader_mode/0.2.2',
      ),
    );
  }
}
