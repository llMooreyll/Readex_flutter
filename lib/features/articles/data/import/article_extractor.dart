import 'package:read_it_later/core/result/result.dart';

class ExtractedArticle {
  const ExtractedArticle({
    required this.title,
    required this.content,
    required this.textContent,
    this.excerpt,
    this.byline,
    this.siteName,
    this.language,
    this.publishedTime,
  });

  final String title;
  final String content;
  final String textContent;
  final String? excerpt;
  final String? byline;
  final String? siteName;
  final String? language;
  final String? publishedTime;
}

abstract interface class ArticleExtractor {
  Future<Result<ExtractedArticle>> extract({
    required String html,
    required Uri baseUri,
  });
}
