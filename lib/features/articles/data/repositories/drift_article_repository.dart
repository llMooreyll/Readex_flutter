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
  Future<Article?> getById(int id) => database.articleDao.getById(id);

  @override
  Future<Article?> findBySourceUrl(Uri url) =>
      database.articleDao.findBySourceUrl(url.toString());

  @override
  Future<int> insert(ArticleDraft draft) =>
      database.articleDao.insertDraft(draft);

  @override
  Future<void> deleteById(int id) => database.articleDao.deleteById(id);
}
