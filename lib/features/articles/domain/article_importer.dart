import 'package:read_it_later/core/result/result.dart';

import 'article_draft.dart';

abstract interface class ArticleImporter {
  Future<Result<ArticleDraft>> import(Uri url);
}
