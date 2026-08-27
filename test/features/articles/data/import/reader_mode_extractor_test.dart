import 'package:flutter_test/flutter_test.dart';
import 'package:read_it_later/core/errors/app_failure.dart';
import 'package:read_it_later/core/result/result.dart';
import 'package:read_it_later/features/articles/data/import/article_extractor.dart';
import 'package:read_it_later/features/articles/data/import/reader_mode_extractor.dart';

void main() {
  const extractor = ReaderModeExtractor();

  test(
    'falls back to the HTML parser for malformed but readable pages',
    () async {
      final result = await extractor.extract(
        html:
            '''
        <!doctype html>
        <html><head><title>Readable article</title></head><body>
          <header><nav>Site navigation</nav></header>
          <main>
            <h1>Readable article</h1>
            <p>${'This is the main article content. ' * 8}</p>
          </main>
        </body></html>
      ''',
        baseUri: Uri.parse('https://example.com/article'),
      );

      expect(result, isA<Success<ExtractedArticle>>());
      expect(
        (result as Success<ExtractedArticle>).value.textContent.length,
        greaterThan(40),
      );
    },
  );

  test('identifies verification pages', () async {
    final result = await extractor.extract(
      html: '<html><body>当前环境异常，完成验证后即可继续访问。</body></html>',
      baseUri: Uri.parse('https://example.com/article'),
    );

    expect(result, isA<Failure<ExtractedArticle>>());
    expect(
      (result as Failure<ExtractedArticle>).failure,
      isA<VerificationRequiredFailure>(),
    );
  });

  test('identifies Next.js shells without article content', () async {
    final result = await extractor.extract(
      html: '<html><body><script>self.__next_f=[]</script></body></html>',
      baseUri: Uri.parse('https://example.com/article'),
    );

    expect(result, isA<Failure<ExtractedArticle>>());
    expect(
      (result as Failure<ExtractedArticle>).failure,
      isA<DynamicContentFailure>(),
    );
  });
}
