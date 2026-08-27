import 'package:read_it_later/core/errors/app_failure.dart';
import 'package:read_it_later/core/result/result.dart';
import 'package:read_it_later/core/utils/url_normalizer.dart';
import 'package:read_it_later/features/articles/domain/article_draft.dart';

import '../domain/article_importer.dart';
import '../domain/article_repository.dart';

enum SaveArticleStage {
  validating,
  checkingDuplicate,
  downloading,
  extracting,
  saving,
}

final class SaveArticleUseCase {
  const SaveArticleUseCase({required this.repository, required this.importer});

  final ArticleRepository repository;
  final ArticleImporter importer;

  Future<Result<int>> execute(
    String rawUrl, {
    void Function(SaveArticleStage stage)? onStage,
  }) async {
    onStage?.call(SaveArticleStage.validating);
    final normalizedResult = UrlNormalizer.normalize(rawUrl);
    if (normalizedResult is Failure<Uri>) {
      return Failure(normalizedResult.failure);
    }
    final url = (normalizedResult as Success<Uri>).value;

    try {
      onStage?.call(SaveArticleStage.checkingDuplicate);
      final existing = await repository.findBySourceUrl(url);
      if (existing != null) {
        return const Failure(DuplicateArticleFailure());
      }

      onStage?.call(SaveArticleStage.downloading);
      onStage?.call(SaveArticleStage.extracting);
      final imported = await importer.import(url);
      if (imported is Failure<ArticleDraft>) {
        return Failure(imported.failure);
      }

      onStage?.call(SaveArticleStage.saving);
      final id = await repository.insert(
        (imported as Success<ArticleDraft>).value,
      );
      return Success(id);
    } on AppFailure catch (failure) {
      return Failure(failure);
    } catch (error) {
      return Failure(UnexpectedFailure(technicalMessage: error.toString()));
    }
  }
}
