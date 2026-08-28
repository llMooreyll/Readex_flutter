import '../../domain/article.dart';
import '../../domain/article_draft.dart';
import '../../domain/article_list_item.dart';
import '../../domain/article_repository.dart';
import '../database/app_database.dart';

final class DriftArticleRepository implements ArticleRepository {
  const DriftArticleRepository(this.database);

  final AppDatabase database;

  @override
  Stream<List<ArticleListItem>> watchAll() => database.articleDao.watchAll();

  @override
  Stream<List<ArticleListItem>> watchArchived() =>
      database.articleDao.watchArchived();

  @override
  Future<Article?> getById(int id) => database.articleDao.getById(id);

  @override
  Future<Article?> findBySourceUrl(Uri url) =>
      database.articleDao.findBySourceUrl(url.toString());

  @override
  Future<int> insert(ArticleDraft draft) =>
      database.articleDao.insertDraft(draft);

  @override
  Future<int> restore(Article article) => database.articleDao.restore(article);

  @override
  Future<void> updateMetadata({
    required int id,
    required String title,
    required String? excerpt,
    required String? author,
    required String? siteName,
    required String? language,
  }) => database.articleDao.updateMetadata(
    id: id,
    title: title,
    excerpt: excerpt,
    author: author,
    siteName: siteName,
    language: language,
  );

  @override
  Future<void> markAsRead(int id) => database.articleDao.markAsRead(id);

  @override
  Future<void> markAsUnread(int id) => database.articleDao.markAsUnread(id);

  @override
  Future<void> archiveById(int id) => database.articleDao.archiveById(id);

  @override
  Future<void> unarchiveById(int id) => database.articleDao.unarchiveById(id);

  @override
  Future<void> deleteById(int id) => database.articleDao.deleteById(id);
}
