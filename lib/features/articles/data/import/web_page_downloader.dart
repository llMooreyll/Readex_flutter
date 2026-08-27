import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:read_it_later/core/errors/app_failure.dart';
import 'package:read_it_later/core/result/result.dart';

import 'http_client_factory.dart';

class DownloadedPage {
  const DownloadedPage({
    required this.html,
    required this.resolvedUri,
    required this.contentType,
  });

  final String html;
  final Uri resolvedUri;
  final String? contentType;
}

final class WebPageDownloader {
  WebPageDownloader({
    this.clientFactory = http.Client.new,
    this.maxBytes = 5 * 1024 * 1024,
    this.timeout = const Duration(seconds: 15),
  });

  final HttpClientFactory clientFactory;
  final int maxBytes;
  final Duration timeout;

  Future<Result<DownloadedPage>> download(Uri url) async {
    final client = clientFactory();
    try {
      final request = http.Request('GET', url)
        ..followRedirects = true
        ..maxRedirects = 5
        ..headers.addAll({
          'Accept': 'text/html,application/xhtml+xml',
          'Accept-Language': 'en-US,en;q=0.8',
          'User-Agent': 'ReadItLater/1.0 (Flutter; Android) AppleWebKit/537.36',
        });

      final response = await client.send(request).timeout(timeout);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        return Failure(HttpStatusFailure(response.statusCode));
      }

      final contentType = response.headers['content-type'];
      if (contentType != null &&
          !contentType.toLowerCase().contains('text/html') &&
          !contentType.toLowerCase().contains('application/xhtml+xml')) {
        return const Failure(UnsupportedContentFailure());
      }

      final builder = BytesBuilder(copy: false);
      var length = 0;
      await for (final chunk in response.stream.timeout(timeout)) {
        length += chunk.length;
        if (length > maxBytes) {
          return const Failure(ContentTooLargeFailure());
        }
        builder.add(chunk);
      }

      final bytes = builder.takeBytes();
      final html = utf8.decode(bytes, allowMalformed: true);
      return Success(
        DownloadedPage(
          html: html,
          resolvedUri: response.request?.url ?? url,
          contentType: contentType,
        ),
      );
    } on TimeoutException {
      return const Failure(NetworkTimeoutFailure());
    } on http.ClientException catch (error) {
      return Failure(
        NetworkUnavailableFailure(technicalMessage: error.message),
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
