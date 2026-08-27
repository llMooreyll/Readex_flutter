import 'article.dart';
import 'article_draft.dart';
import 'article_list_item.dart';

abstract interface class ArticleRepository {
  Stream<List<ArticleListItem>> watchAll();

  Future<Article?> getById(int id);

  Future<Article?> findBySourceUrl(Uri url);

  Future<int> insert(ArticleDraft draft);

  Future<void> deleteById(int id);
}
