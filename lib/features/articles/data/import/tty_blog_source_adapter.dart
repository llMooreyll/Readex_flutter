import 'dart:async';
import 'dart:convert';

import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;
import 'package:read_it_later/core/errors/app_failure.dart';
import 'package:read_it_later/core/result/result.dart';

import 'article_extractor.dart';
import 'article_source_adapter.dart';
import 'http_client_factory.dart';

final class TtyBlogSourceAdapter implements ArticleSourceAdapter {
  TtyBlogSourceAdapter({this.clientFactory = http.Client.new});

  static const _host = 'blog.tty.mom';

  final HttpClientFactory clientFactory;

  @override
  bool canHandle(Uri url) => url.host.toLowerCase() == _host;

  @override
  Future<Result<ExtractedArticle>> extract(Uri url) async {
    final client = clientFactory();
    try {
      final slug = url.pathSegments.isEmpty ? '' : url.pathSegments.last;
      if (slug.isEmpty) {
        return const Failure(ArticleNotReadableFailure());
      }

      final endpoint = Uri.https(_host, '/api/posts/$slug');
      final response = await client
          .get(
            endpoint,
            headers: const {
              'Accept': 'application/json',
              'User-Agent': 'ReadItLater/1.0 (Flutter; Android)',
            },
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return Failure(HttpStatusFailure(response.statusCode));
      }

      final payload = jsonDecode(response.body);
      if (payload is! Map<String, dynamic>) {
        return const Failure(ArticleNotReadableFailure());
      }

      final title = payload['title']?.toString().trim() ?? '';
      final content = payload['content']?.toString() ?? '';
      final textContent = htmlToText(content);
      if (title.isEmpty || textContent.length < 40) {
        return const Failure(ArticleNotReadableFailure());
      }

      final publishedAt = payload['published_at']?.toString();
      return Success(
        ExtractedArticle(
          title: title,
          content: content,
          textContent: textContent,
          excerpt: payload['description']?.toString().trim(),
          siteName: 'TTY Blog',
          language: null,
          publishedTime: publishedAt,
        ),
      );
    } on TimeoutException {
      return const Failure(NetworkTimeoutFailure());
    } on http.ClientException catch (error) {
      return Failure(
        NetworkUnavailableFailure(technicalMessage: error.message),
      );
    } on FormatException catch (error) {
      return Failure(
        UnexpectedFailure(technicalMessage: 'TTY Blog response: $error'),
      );
    } catch (error) {
      return Failure(
        NetworkUnavailableFailure(technicalMessage: error.toString()),
      );
    } finally {
      client.close();
    }
  }
}

String htmlToText(String html) {
  return html_parser
          .parseFragment(html)
          .text
          ?.replaceAll(RegExp(r'\s+'), ' ')
          .trim() ??
      '';
}
