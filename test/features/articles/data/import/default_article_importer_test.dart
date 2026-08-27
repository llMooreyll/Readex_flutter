import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:read_it_later/core/errors/app_failure.dart';
import 'package:read_it_later/core/result/result.dart';
import 'package:read_it_later/features/articles/data/import/article_extractor.dart';
import 'package:read_it_later/features/articles/data/import/article_html_sanitizer.dart';
import 'package:read_it_later/features/articles/data/import/default_article_importer.dart';
import 'package:read_it_later/features/articles/data/import/web_page_downloader.dart';
import 'package:read_it_later/features/articles/domain/article_draft.dart';

void main() {
  test(
    'saves a link-only draft when downloaded HTML is not readable',
    () async {
      final importer = DefaultArticleImporter(
        downloader: WebPageDownloader(
          clientFactory: () => MockClient((request) async {
            return http.Response(
              '''
            <!doctype html>
            <html>
              <head>
                <meta property="og:title" content="Protected article">
                <meta property="og:site_name" content="Example Site">
              </head>
              <body>Verification required.</body>
            </html>
            ''',
              200,
              request: request,
              headers: {'content-type': 'text/html; charset=utf-8'},
            );
          }),
        ),
        extractor: const _FailingExtractor(VerificationRequiredFailure()),
        sanitizer: ArticleHtmlSanitizer(),
      );

      final result = await importer.import(
        Uri.parse('https://example.com/story'),
      );

      expect(result, isA<Success<ArticleDraft>>());
      final draft = (result as Success<ArticleDraft>).value;
      expect(draft.title, 'Protected article');
      expect(draft.siteName, 'Example Site');
      expect(draft.extractorVersion, 'link-only/1.0');
      expect(draft.estimatedReadingMinutes, 0);
      expect(draft.contentHtml, isEmpty);
      expect(draft.contentText, isEmpty);
    },
  );
}

final class _FailingExtractor implements ArticleExtractor {
  const _FailingExtractor(this.failure);

  final AppFailure failure;

  @override
  Future<Result<ExtractedArticle>> extract({
    required String html,
    required Uri baseUri,
  }) async {
    return Failure(failure);
  }
}
