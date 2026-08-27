import 'package:html/dom.dart' as html_dom;
import 'package:html/parser.dart' as html_parser;
import 'package:read_it_later/core/errors/app_failure.dart';
import 'package:read_it_later/core/result/result.dart';
import 'package:read_it_later/core/utils/reading_time.dart';
import 'package:read_it_later/features/articles/domain/article_draft.dart';
import 'package:read_it_later/features/articles/domain/article_importer.dart';

import 'article_extractor.dart';
import 'article_html_sanitizer.dart';
import 'web_page_downloader.dart';

final class DefaultArticleImporter implements ArticleImporter {
  const DefaultArticleImporter({
    required this.downloader,
    required this.extractor,
    required this.sanitizer,
    this.operationTimeout = const Duration(seconds: 30),
  });

  final WebPageDownloader downloader;
  final ArticleExtractor extractor;
  final ArticleHtmlSanitizer sanitizer;
  final Duration operationTimeout;

  @override
  Future<Result<ArticleDraft>> import(Uri url) {
    return _import(url).timeout(
      operationTimeout,
      onTimeout: () => const Failure(NetworkTimeoutFailure()),
    );
  }

  Future<Result<ArticleDraft>> _import(Uri url) async {
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
      if (_canSaveLinkOnly(extracted.failure)) {
        return _buildLinkOnlyDraft(
          sourceUrl: url,
          resolvedUrl: url,
          sourceHtml: page.html,
        );
      }
      return Failure(extracted.failure);
    }
    return _buildDraft(
      sourceUrl: url,
      resolvedUrl: page.resolvedUri,
      extracted: extracted,
      sourceHtml: page.html,
    );
  }

  bool _canSaveLinkOnly(AppFailure failure) {
    return failure is VerificationRequiredFailure ||
        failure is DynamicContentFailure ||
        failure is ArticleNotReadableFailure;
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
      if (_canSaveLinkOnly(sanitized.failure) && sourceHtml != null) {
        return _buildLinkOnlyDraft(
          sourceUrl: sourceUrl,
          resolvedUrl: sourceUrl,
          sourceHtml: sourceHtml,
        );
      }
      return Failure(sanitized.failure);
    }
    final content = (sanitized as Success<SanitizedArticle>).value;
    final title = article.title.trim();
    if (title.isEmpty || content.text.length < 40) {
      if (sourceHtml != null) {
        return _buildLinkOnlyDraft(
          sourceUrl: sourceUrl,
          resolvedUrl: sourceUrl,
          sourceHtml: sourceHtml,
        );
      }
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

  Result<ArticleDraft> _buildLinkOnlyDraft({
    required Uri sourceUrl,
    required Uri resolvedUrl,
    required String sourceHtml,
  }) {
    final document = html_parser.parse(sourceHtml);
    final metadata = _extractMetadata(document, resolvedUrl);
    final title = metadata.title ?? _fallbackTitle(sourceUrl);

    return Success(
      ArticleDraft(
        sourceUrl: sourceUrl.toString(),
        resolvedUrl: resolvedUrl.toString(),
        canonicalUrl: metadata.canonicalUrl,
        title: title,
        siteName: metadata.siteName ?? sourceUrl.host,
        contentHtml: '',
        contentText: '',
        estimatedReadingMinutes: 0,
        extractorVersion: 'link-only/1.0',
      ),
    );
  }

  _DocumentMetadata _extractMetadata(
    html_dom.Document document,
    Uri resolvedUrl,
  ) {
    String? metaContent(String selector) {
      final value = document.querySelector(selector)?.attributes['content'];
      final trimmed = value?.replaceAll(RegExp(r'\s+'), ' ').trim();
      return trimmed == null || trimmed.isEmpty ? null : trimmed;
    }

    final title =
        metaContent('meta[property="og:title"]') ??
        metaContent('meta[name="twitter:title"]') ??
        document.querySelector('title')?.text.trim();
    final canonicalRaw = document
        .querySelector('link[rel="canonical"]')
        ?.attributes['href'];
    final canonicalUrl = canonicalRaw == null
        ? null
        : resolvedUrl.resolve(canonicalRaw).toString();

    return _DocumentMetadata(
      title: title == null || title.isEmpty ? null : title,
      canonicalUrl: canonicalUrl,
      siteName:
          metaContent('meta[property="og:site_name"]') ??
          metaContent('meta[name="application-name"]'),
    );
  }

  String _fallbackTitle(Uri sourceUrl) {
    final host = sourceUrl.host.isEmpty ? 'webpage' : sourceUrl.host;
    return 'Saved link from $host';
  }
}

final class _DocumentMetadata {
  const _DocumentMetadata({this.title, this.canonicalUrl, this.siteName});

  final String? title;
  final String? canonicalUrl;
  final String? siteName;
}
