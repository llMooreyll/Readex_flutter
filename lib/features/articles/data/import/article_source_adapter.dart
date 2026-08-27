import 'package:read_it_later/core/result/result.dart';

import 'article_extractor.dart';

abstract interface class ArticleSourceAdapter {
  bool canHandle(Uri url);

  Future<Result<ExtractedArticle>> extract(Uri url);
}
