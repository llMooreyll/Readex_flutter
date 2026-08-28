import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:read_it_later/features/articles/data/database/app_database.dart';
import 'package:read_it_later/features/articles/data/repositories/drift_article_repository.dart';
import 'package:read_it_later/features/articles/domain/article_draft.dart';

void main() {
  late AppDatabase database;
  late DriftArticleRepository repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = DriftArticleRepository(database);
  });

  tearDown(() => database.close());

  test('inserts, watches, reads, and deletes an article', () async {
    final draft = ArticleDraft(
      sourceUrl: 'https://example.com/story',
      resolvedUrl: 'https://example.com/story',
      title: 'A saved story',
      excerpt: 'A short summary.',
      author: 'Author',
      siteName: 'Example',
      contentHtml: '<p>${'Readable article text. ' * 4}</p>',
      contentText: 'Readable article text. ' * 4,
      estimatedReadingMinutes: 1,
      extractorVersion: 'test',
    );

    final id = await repository.insert(draft);
    final list = await repository.watchAll().first;
    final article = await repository.getById(id);

    expect(list, hasLength(1));
    expect(list.single.id, id);
    expect(list.single.title, 'A saved story');
    expect(article?.contentText, contains('Readable article text.'));
    expect(
      (await repository.findBySourceUrl(Uri.parse(draft.sourceUrl)))?.id,
      id,
    );

    await repository.deleteById(id);
    expect(await repository.getById(id), isNull);
    expect(await repository.watchAll().first, isEmpty);
  });

  test('enforces unique source URLs', () async {
    final draft = ArticleDraft(
      sourceUrl: 'https://example.com/duplicate',
      resolvedUrl: 'https://example.com/duplicate',
      title: 'Duplicate test',
      contentHtml: '<p>${'Readable article text. ' * 4}</p>',
      contentText: 'Readable article text. ' * 4,
      estimatedReadingMinutes: 1,
      extractorVersion: 'test',
    );

    await repository.insert(draft);
    expect(() => repository.insert(draft), throwsA(isA<Exception>()));
  });

  test('updates read, archive, and metadata state', () async {
    final draft = ArticleDraft(
      sourceUrl: 'https://example.com/state',
      resolvedUrl: 'https://example.com/state',
      title: 'State test',
      contentHtml: '<p>${'Readable article text. ' * 4}</p>',
      contentText: 'Readable article text. ' * 4,
      estimatedReadingMinutes: 1,
      extractorVersion: 'test',
    );

    final id = await repository.insert(draft);
    expect(await repository.watchAll().first, hasLength(1));
    expect(await repository.watchArchived().first, isEmpty);

    await repository.markAsRead(id);
    var article = await repository.getById(id);
    expect(article?.isRead, isTrue);

    await repository.markAsUnread(id);
    article = await repository.getById(id);
    expect(article?.isRead, isFalse);

    await repository.archiveById(id);
    expect(await repository.watchAll().first, isEmpty);
    expect(await repository.watchArchived().first, hasLength(1));

    await repository.unarchiveById(id);
    expect(await repository.watchAll().first, hasLength(1));
    expect(await repository.watchArchived().first, isEmpty);

    await repository.updateMetadata(
      id: id,
      title: 'Updated title',
      excerpt: 'Updated excerpt',
      author: 'Updated author',
      siteName: 'Updated site',
      language: 'en',
    );
    article = await repository.getById(id);
    expect(article?.title, 'Updated title');
    expect(article?.excerpt, 'Updated excerpt');
    expect(article?.author, 'Updated author');
    expect(article?.siteName, 'Updated site');
    expect(article?.language, 'en');
  });

  test('restores a deleted article for undo', () async {
    final draft = ArticleDraft(
      sourceUrl: 'https://example.com/restore',
      resolvedUrl: 'https://example.com/restore',
      title: 'Restore test',
      contentHtml: '<p>${'Readable article text. ' * 4}</p>',
      contentText: 'Readable article text. ' * 4,
      estimatedReadingMinutes: 1,
      extractorVersion: 'test',
    );

    final id = await repository.insert(draft);
    await repository.markAsRead(id);
    await repository.archiveById(id);
    final article = await repository.getById(id);

    await repository.deleteById(id);
    expect(await repository.getById(id), isNull);

    await repository.restore(article!);
    final restored = await repository.getById(id);
    expect(restored?.title, 'Restore test');
    expect(restored?.isRead, isTrue);
    expect(restored?.isArchived, isTrue);
  });
}
