import 'article.dart';
import 'article_draft.dart';
import 'article_list_item.dart';

abstract interface class ArticleRepository {
  Stream<List<ArticleListItem>> watchAll();

  Stream<List<ArticleListItem>> watchArchived();

  Future<Article?> getById(int id);

  Future<Article?> findBySourceUrl(Uri url);

  Future<int> insert(ArticleDraft draft);

  Future<int> restore(Article article);

  Future<void> updateMetadata({
    required int id,
    required String title,
    required String? excerpt,
    required String? author,
    required String? siteName,
    required String? language,
  });

  Future<void> markAsRead(int id);

  Future<void> markAsUnread(int id);

  Future<void> archiveById(int id);

  Future<void> unarchiveById(int id);

  Future<void> deleteById(int id);
}
