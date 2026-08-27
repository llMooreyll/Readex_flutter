import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:read_it_later/core/result/result.dart';
import 'package:read_it_later/features/articles/data/import/article_extractor.dart';
import 'package:read_it_later/features/articles/data/import/tty_blog_source_adapter.dart';

void main() {
  test('loads article content from the public TTY API', () async {
    final client = MockClient((request) async {
      expect(request.url.toString(), contains('/api/posts/hello-world'));
      return http.Response(
        '{"title":"Hello World","description":"Summary","content":"<p>${'Readable article content. ' * 3}</p>","published_at":"2026-08-27T12:00:00"}',
        200,
        headers: {'content-type': 'application/json'},
      );
    });
    final adapter = TtyBlogSourceAdapter(clientFactory: () => client);

    final result = await adapter.extract(
      Uri.parse('https://blog.tty.mom/posts/hello-world'),
    );

    expect(result, isA<Success<ExtractedArticle>>());
    final article = (result as Success<ExtractedArticle>).value;
    expect(article.title, 'Hello World');
    expect(article.textContent, contains('Readable article content.'));
  });
}
