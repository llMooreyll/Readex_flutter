import 'package:flutter_test/flutter_test.dart';
import 'package:read_it_later/core/errors/app_failure.dart';
import 'package:read_it_later/core/result/result.dart';
import 'package:read_it_later/core/utils/url_normalizer.dart';

void main() {
  test('adds HTTPS and removes fragments', () {
    final result = UrlNormalizer.normalize(' Example.COM/article#comments ');

    expect(result, isA<Success<Uri>>());
    final uri = (result as Success<Uri>).value;
    expect(uri.toString(), 'https://example.com/article');
  });

  test('rejects non-HTTPS URLs', () {
    final result = UrlNormalizer.normalize('http://example.com/article');

    expect(result, isA<Failure<Uri>>());
    expect((result as Failure<Uri>).failure, isA<InvalidUrlFailure>());
  });

  test('rejects credentials and missing hosts', () {
    expect(
      UrlNormalizer.normalize('https://user@example.com').isSuccess,
      isFalse,
    );
    expect(UrlNormalizer.normalize('https:///article').isSuccess, isFalse);
  });
}
