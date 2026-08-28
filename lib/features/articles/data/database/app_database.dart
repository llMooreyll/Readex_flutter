import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'article_dao.dart';

part 'app_database.g.dart';

@DataClassName('ArticleRow')
class Articles extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get sourceUrl => text().unique()();

  TextColumn get resolvedUrl => text()();

  TextColumn get canonicalUrl => text().nullable()();

  TextColumn get title => text()();

  TextColumn get excerpt => text().nullable()();

  TextColumn get author => text().nullable()();

  TextColumn get siteName => text().nullable()();

  TextColumn get language => text().nullable()();

  DateTimeColumn get publishedAt => dateTime().nullable()();

  DateTimeColumn get readAt => dateTime().nullable()();

  DateTimeColumn get archivedAt => dateTime().nullable()();

  TextColumn get contentHtml => text()();

  TextColumn get contentText => text()();

  IntColumn get estimatedReadingMinutes => integer()();

  TextColumn get extractorVersion => text()();

  DateTimeColumn get savedAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();
}

@DriftDatabase(tables: [Articles], daos: [ArticleDao])
final class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? implementation])
    : super(implementation ?? driftDatabase(name: 'read_it_later'));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator migrator) async {
      await migrator.createAll();
      await customStatement(
        'CREATE INDEX articles_saved_at_idx ON articles (saved_at DESC)',
      );
    },
    onUpgrade: (Migrator migrator, int from, int to) async {
      if (from < 2) {
        await migrator.addColumn(articles, articles.readAt);
        await migrator.addColumn(articles, articles.archivedAt);
        await customStatement(
          'CREATE INDEX articles_archived_at_idx ON articles (archived_at)',
        );
      }
    },
  );
}
