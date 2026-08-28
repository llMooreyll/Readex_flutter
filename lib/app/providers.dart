import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_it_later/features/articles/application/archive_article_use_case.dart';
import 'package:read_it_later/features/articles/application/delete_article_use_case.dart';
import 'package:read_it_later/features/articles/application/mark_article_read_use_case.dart';
import 'package:read_it_later/features/articles/application/save_article_use_case.dart';
import 'package:read_it_later/features/articles/application/update_article_metadata_use_case.dart';
import 'package:read_it_later/features/articles/data/database/app_database.dart';
import 'package:read_it_later/features/articles/data/import/article_html_sanitizer.dart';
import 'package:read_it_later/features/articles/data/import/default_article_importer.dart';
import 'package:read_it_later/features/articles/data/import/reader_mode_extractor.dart';
import 'package:read_it_later/features/articles/data/import/web_page_downloader.dart';
import 'package:read_it_later/features/articles/data/repositories/drift_article_repository.dart';
import 'package:read_it_later/features/articles/domain/article.dart';
import 'package:read_it_later/features/articles/domain/article_importer.dart';
import 'package:read_it_later/features/articles/domain/article_list_item.dart';
import 'package:read_it_later/features/articles/domain/article_repository.dart';

import '../features/articles/presentation/controllers/save_article_controller.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

final articleRepositoryProvider = Provider<ArticleRepository>((ref) {
  return DriftArticleRepository(ref.watch(appDatabaseProvider));
});

final webPageDownloaderProvider = Provider<WebPageDownloader>((ref) {
  return WebPageDownloader();
});

final articleImporterProvider = Provider<ArticleImporter>((ref) {
  return DefaultArticleImporter(
    downloader: ref.watch(webPageDownloaderProvider),
    extractor: const ReaderModeExtractor(),
    sanitizer: ArticleHtmlSanitizer(),
  );
});

final saveArticleUseCaseProvider = Provider<SaveArticleUseCase>((ref) {
  return SaveArticleUseCase(
    repository: ref.watch(articleRepositoryProvider),
    importer: ref.watch(articleImporterProvider),
  );
});

final deleteArticleUseCaseProvider = Provider<DeleteArticleUseCase>((ref) {
  return DeleteArticleUseCase(repository: ref.watch(articleRepositoryProvider));
});

final archiveArticleUseCaseProvider = Provider<ArchiveArticleUseCase>((ref) {
  return ArchiveArticleUseCase(
    repository: ref.watch(articleRepositoryProvider),
  );
});

final markArticleReadUseCaseProvider = Provider<MarkArticleReadUseCase>((ref) {
  return MarkArticleReadUseCase(
    repository: ref.watch(articleRepositoryProvider),
  );
});

final updateArticleMetadataUseCaseProvider =
    Provider<UpdateArticleMetadataUseCase>((ref) {
      return UpdateArticleMetadataUseCase(
        repository: ref.watch(articleRepositoryProvider),
      );
    });

final saveArticleControllerProvider =
    StateNotifierProvider<SaveArticleController, SaveArticleState>((ref) {
      return SaveArticleController(ref.watch(saveArticleUseCaseProvider));
    });

final articleListProvider = StreamProvider<List<ArticleListItem>>((ref) {
  return ref.watch(articleRepositoryProvider).watchAll();
});

final archivedArticleListProvider = StreamProvider<List<ArticleListItem>>((
  ref,
) {
  return ref.watch(articleRepositoryProvider).watchArchived();
});

final articleByIdProvider = FutureProvider.family<Article?, int>((ref, id) {
  return ref.watch(articleRepositoryProvider).getById(id);
});
