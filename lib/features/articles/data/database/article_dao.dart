import 'package:drift/drift.dart';

import '../../domain/article.dart' as domain;
import '../../domain/article_draft.dart';
import '../../domain/article_list_item.dart';
import 'app_database.dart';

part 'article_dao.g.dart';

@DriftAccessor(tables: [Articles])
final class ArticleDao extends DatabaseAccessor<AppDatabase>
    with _$ArticleDaoMixin {
  ArticleDao(super.attachedDatabase);

  Stream<List<ArticleListItem>> watchAll() {
    return _watchByArchived(false);
  }

  Stream<List<ArticleListItem>> watchArchived() {
    return _watchByArchived(true);
  }

  Stream<List<ArticleListItem>> _watchByArchived(bool archived) {
    final query = select(articles)
      ..where(
        (table) =>
            archived ? table.archivedAt.isNotNull() : table.archivedAt.isNull(),
      )
      ..orderBy([(table) => OrderingTerm.desc(table.savedAt)]);
    return query.watch().map(
      (rows) => rows.map(_toListItem).toList(growable: false),
    );
  }

  Future<domain.Article?> getById(int id) async {
    final row = await (select(
      articles,
    )..where((table) => table.id.equals(id))).getSingleOrNull();
    return row == null ? null : _toArticle(row);
  }

  Future<domain.Article?> findBySourceUrl(String sourceUrl) async {
    final row = await (select(
      articles,
    )..where((table) => table.sourceUrl.equals(sourceUrl))).getSingleOrNull();
    return row == null ? null : _toArticle(row);
  }

  Future<int> insertDraft(ArticleDraft draft) {
    final now = DateTime.now().toUtc();
    return into(articles).insert(
      ArticlesCompanion.insert(
        sourceUrl: draft.sourceUrl,
        resolvedUrl: draft.resolvedUrl,
        title: draft.title,
        contentHtml: draft.contentHtml,
        contentText: draft.contentText,
        estimatedReadingMinutes: draft.estimatedReadingMinutes,
        extractorVersion: draft.extractorVersion,
        savedAt: now,
        updatedAt: now,
        canonicalUrl: Value(draft.canonicalUrl),
        excerpt: Value(draft.excerpt),
        author: Value(draft.author),
        siteName: Value(draft.siteName),
        language: Value(draft.language),
        publishedAt: Value(draft.publishedAt?.toUtc()),
      ),
    );
  }

  Future<int> restore(domain.Article article) {
    return into(articles).insert(
      ArticlesCompanion(
        id: Value(article.id),
        sourceUrl: Value(article.sourceUrl),
        resolvedUrl: Value(article.resolvedUrl),
        canonicalUrl: Value(article.canonicalUrl),
        title: Value(article.title),
        excerpt: Value(article.excerpt),
        author: Value(article.author),
        siteName: Value(article.siteName),
        language: Value(article.language),
        publishedAt: Value(article.publishedAt?.toUtc()),
        contentHtml: Value(article.contentHtml),
        contentText: Value(article.contentText),
        estimatedReadingMinutes: Value(article.estimatedReadingMinutes),
        extractorVersion: Value(article.extractorVersion),
        savedAt: Value(article.savedAt.toUtc()),
        updatedAt: Value(article.updatedAt.toUtc()),
        readAt: Value(article.readAt?.toUtc()),
        archivedAt: Value(article.archivedAt?.toUtc()),
      ),
    );
  }

  Future<void> updateMetadata({
    required int id,
    required String title,
    required String? excerpt,
    required String? author,
    required String? siteName,
    required String? language,
  }) async {
    await (update(articles)..where((table) => table.id.equals(id))).write(
      ArticlesCompanion(
        title: Value(title),
        excerpt: Value(excerpt),
        author: Value(author),
        siteName: Value(siteName),
        language: Value(language),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  Future<void> markAsRead(int id) async {
    await (update(articles)..where((table) => table.id.equals(id))).write(
      ArticlesCompanion(
        readAt: Value(DateTime.now().toUtc()),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  Future<void> markAsUnread(int id) async {
    await (update(articles)..where((table) => table.id.equals(id))).write(
      ArticlesCompanion(
        readAt: const Value(null),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  Future<void> archiveById(int id) async {
    await (update(articles)..where((table) => table.id.equals(id))).write(
      ArticlesCompanion(
        archivedAt: Value(DateTime.now().toUtc()),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  Future<void> unarchiveById(int id) async {
    await (update(articles)..where((table) => table.id.equals(id))).write(
      ArticlesCompanion(
        archivedAt: const Value(null),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  Future<void> deleteById(int id) async {
    await (delete(articles)..where((table) => table.id.equals(id))).go();
  }

  ArticleListItem _toListItem(ArticleRow row) {
    return ArticleListItem(
      id: row.id,
      title: row.title,
      sourceUrl: row.sourceUrl,
      excerpt: row.excerpt,
      author: row.author,
      siteName: row.siteName,
      estimatedReadingMinutes: row.estimatedReadingMinutes,
      isLinkOnly: row.extractorVersion.startsWith('link-only/'),
      readAt: row.readAt?.toLocal(),
      archivedAt: row.archivedAt?.toLocal(),
      savedAt: row.savedAt.toLocal(),
    );
  }

  domain.Article _toArticle(ArticleRow row) {
    return domain.Article(
      id: row.id,
      sourceUrl: row.sourceUrl,
      resolvedUrl: row.resolvedUrl,
      canonicalUrl: row.canonicalUrl,
      title: row.title,
      excerpt: row.excerpt,
      author: row.author,
      siteName: row.siteName,
      language: row.language,
      publishedAt: row.publishedAt?.toLocal(),
      readAt: row.readAt?.toLocal(),
      archivedAt: row.archivedAt?.toLocal(),
      contentHtml: row.contentHtml,
      contentText: row.contentText,
      estimatedReadingMinutes: row.estimatedReadingMinutes,
      extractorVersion: row.extractorVersion,
      savedAt: row.savedAt.toLocal(),
      updatedAt: row.updatedAt.toLocal(),
    );
  }
}
