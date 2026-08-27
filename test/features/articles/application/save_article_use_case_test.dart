import 'package:flutter_test/flutter_test.dart';
import 'package:read_it_later/core/errors/app_failure.dart';
import 'package:read_it_later/core/result/result.dart';
import 'package:read_it_later/features/articles/application/save_article_use_case.dart';
import 'package:read_it_later/features/articles/domain/article.dart';
import 'package:read_it_later/features/articles/domain/article_draft.dart';
import 'package:read_it_later/features/articles/domain/article_importer.dart';
import 'package:read_it_later/features/articles/domain/article_list_item.dart';
import 'package:read_it_later/features/articles/domain/article_repository.dart';

void main() {
  test('normalizes, imports, saves, and reports stages', () async {
    final repository = FakeArticleRepository();
    final importer = FakeArticleImporter();
    final useCase = SaveArticleUseCase(
      repository: repository,
      importer: importer,
    );
    final stages = <SaveArticleStage>[];

    final result = await useCase.execute(
      'example.com/story#comments',
      onStage: stages.add,
    );

    expect(result, isA<Success<int>>());
    expect((result as Success<int>).value, 42);
    expect(importer.receivedUrl.toString(), 'https://example.com/story');
    expect(repository.savedDraft?.sourceUrl, 'https://example.com/story');
    expect(stages, [
      SaveArticleStage.validating,
      SaveArticleStage.checkingDuplicate,
      SaveArticleStage.downloading,
      SaveArticleStage.extracting,
      SaveArticleStage.saving,
    ]);
  });

  test('returns a duplicate failure before importing', () async {
    final repository = FakeArticleRepository(existing: true);
    final importer = FakeArticleImporter();
    final result = await SaveArticleUseCase(
      repository: repository,
      importer: importer,
    ).execute('https://example.com/story');

    expect(result, isA<Failure<int>>());
    expect((result as Failure<int>).failure, isA<DuplicateArticleFailure>());
    expect(importer.receivedUrl, isNull);
  });
}

final class FakeArticleImporter implements ArticleImporter {
  Uri? receivedUrl;

  @override
  Future<Result<ArticleDraft>> import(Uri url) async {
    receivedUrl = url;
    return Success(
      ArticleDraft(
        sourceUrl: url.toString(),
        resolvedUrl: url.toString(),
        title: 'Imported story',
        contentHtml: '<p>${'Readable article text. ' * 4}</p>',
        contentText: 'Readable article text. ' * 4,
        estimatedReadingMinutes: 1,
        extractorVersion: 'test',
      ),
    );
  }
}

final class FakeArticleRepository implements ArticleRepository {
  FakeArticleRepository({this.existing = false});

  final bool existing;
  ArticleDraft? savedDraft;

  @override
  Future<Article?> findBySourceUrl(Uri url) async {
    if (!existing) {
      return null;
    }
    return Article(
      id: 1,
      sourceUrl: url.toString(),
      resolvedUrl: url.toString(),
      title: 'Existing story',
      contentHtml: '<p>Existing</p>',
      contentText: 'Existing',
      estimatedReadingMinutes: 1,
      extractorVersion: 'test',
      savedAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026),
    );
  }

  @override
  Future<int> insert(ArticleDraft draft) async {
    savedDraft = draft;
    return 42;
  }

  @override
  Future<Article?> getById(int id) async => null;

  @override
  Stream<List<ArticleListItem>> watchAll() => Stream.value(const []);

  @override
  Future<void> deleteById(int id) async {}
}
