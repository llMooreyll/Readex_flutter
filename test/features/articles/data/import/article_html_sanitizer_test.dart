import 'package:flutter_test/flutter_test.dart';
import 'package:read_it_later/core/errors/app_failure.dart';
import 'package:read_it_later/core/result/result.dart';
import 'package:read_it_later/features/articles/data/import/article_html_sanitizer.dart';

void main() {
  final baseUri = Uri.parse('https://example.com/articles/story');
  final sanitizer = ArticleHtmlSanitizer();

  test('removes executable content and keeps safe article markup', () {
    final result = sanitizer.sanitize(
      html:
          '''
        <div>
          <h2>Readable title</h2>
          <p>${'Readable article text. ' * 4}</p>
          <script>alert("bad")</script>
          <a href="/source">Source</a>
          <img src="https://cdn.example.com/image.jpg" alt="Cover">
        </div>
      ''',
      baseUri: baseUri,
    );

    expect(
      result,
      isA<Success<SanitizedArticle>>(),
      reason: result is Failure<SanitizedArticle>
          ? result.failure.toString()
          : null,
    );
    final value = (result as Success<SanitizedArticle>).value;
    expect(value.html, contains('<h2>Readable title</h2>'));
    expect(value.html, contains('href="https://example.com/source"'));
    expect(value.html, contains('src="https://cdn.example.com/image.jpg"'));
    expect(value.html, isNot(contains('<script')));
    expect(value.html, isNot(contains('alert')));
  });

  test('removes unsafe links and images', () {
    final result = sanitizer.sanitize(
      html:
          '<p>${'Readable article text. ' * 4}</p>'
          '<a href="javascript:alert(1)">bad</a>'
          '<img src="file:///secret.png">',
      baseUri: baseUri,
    );

    expect(result, isA<Success<SanitizedArticle>>());
    final value = (result as Success<SanitizedArticle>).value;
    expect(value.html, contains('<a>bad</a>'));
    expect(value.html, isNot(contains('javascript:')));
    expect(value.html, isNot(contains('file:///')));
  });

  test('uses lazy image attributes when src is an unsafe placeholder', () {
    final result = sanitizer.sanitize(
      html:
          '<p>${'Readable article text. ' * 4}</p>'
          '<img src="https://example.com/img-placeholder.png" '
          'data-original="//cdn.example.com/article/photo.jpg" '
          'alt="Article photo">',
      baseUri: baseUri,
    );

    expect(result, isA<Success<SanitizedArticle>>());
    final value = (result as Success<SanitizedArticle>).value;
    expect(
      value.html,
      contains('src="https://cdn.example.com/article/photo.jpg"'),
    );
    expect(value.html, contains('alt="Article photo"'));
  });

  test('uses the largest safe srcset candidate for lazy images', () {
    final result = sanitizer.sanitize(
      html:
          '<p>${'Readable article text. ' * 4}</p>'
          '<img data-srcset="/small.jpg 480w, /large.jpg 1120w">',
      baseUri: baseUri,
    );

    expect(result, isA<Success<SanitizedArticle>>());
    final value = (result as Success<SanitizedArticle>).value;
    expect(value.html, contains('src="https://example.com/large.jpg"'));
  });

  test('preserves article semantics and safe structural attributes', () {
    final result = sanitizer.sanitize(
      html:
          '<article id="story">'
          '<p><b>Bold</b> <i>italic</i> <u>underlined</u> '
          '<s>removed</s> H<sub>2</sub>O x<sup>2</sup></p>'
          '<blockquote cite="/quote">Quoted text</blockquote>'
          '<pre><code>final value = 42;</code></pre>'
          '<figure><img src="/photo.jpg" width="640" height="360">'
          '<figcaption>Photo caption</figcaption></figure>'
          '<table border="1"><thead><tr><th scope="col">Name</th></tr></thead>'
          '<tbody><tr><td>Value</td></tr></tbody></table>'
          '</article><style>bad</style>',
      baseUri: baseUri,
    );

    expect(result, isA<Success<SanitizedArticle>>());
    final value = (result as Success<SanitizedArticle>).value;
    expect(value.html, contains('<b>Bold</b>'));
    expect(value.html, contains('<i>italic</i>'));
    expect(
      value.html,
      contains('<blockquote cite="https://example.com/quote">'),
    );
    expect(value.html, contains('<pre><code>final value = 42;</code></pre>'));
    expect(value.html, contains('<figcaption>Photo caption</figcaption>'));
    expect(value.html, contains('scope="col"'));
    expect(value.html, isNot(contains('<style')));
  });

  test('keeps in-page anchors but removes unsafe external schemes', () {
    final result = sanitizer.sanitize(
      html:
          '<p>${'Readable article text. ' * 4}</p>'
          '<a href="#footnote-1">Footnote</a>'
          '<a href="javascript:alert(1)">Unsafe</a>',
      baseUri: baseUri,
    );

    expect(result, isA<Success<SanitizedArticle>>());
    final value = (result as Success<SanitizedArticle>).value;
    expect(value.html, contains('href="#footnote-1"'));
    expect(value.html, contains('<a>Unsafe</a>'));
  });

  test('rejects content that is too short', () {
    final result = sanitizer.sanitize(
      html: '<p>Too short</p>',
      baseUri: baseUri,
    );

    expect(result, isA<Failure<SanitizedArticle>>());
    expect(
      (result as Failure<SanitizedArticle>).failure,
      isA<ArticleNotReadableFailure>(),
    );
  });
}
