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
    final query = select(articles)
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
      contentHtml: row.contentHtml,
      contentText: row.contentText,
      estimatedReadingMinutes: row.estimatedReadingMinutes,
      extractorVersion: row.extractorVersion,
      savedAt: row.savedAt.toLocal(),
      updatedAt: row.updatedAt.toLocal(),
    );
  }
}
