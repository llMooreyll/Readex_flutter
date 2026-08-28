import 'package:read_it_later/core/errors/app_failure.dart';
import 'package:read_it_later/core/result/result.dart';

import '../domain/article_repository.dart';

final class UpdateArticleMetadataUseCase {
  const UpdateArticleMetadataUseCase({required this.repository});

  final ArticleRepository repository;

  Future<Result<void>> execute({
    required int id,
    required String title,
    required String? excerpt,
    required String? author,
    required String? siteName,
    required String? language,
  }) async {
    final normalizedTitle = title.trim();
    if (normalizedTitle.isEmpty) {
      return const Failure(EmptyTitleFailure());
    }

    await repository.updateMetadata(
      id: id,
      title: normalizedTitle,
      excerpt: _nullableTrim(excerpt),
      author: _nullableTrim(author),
      siteName: _nullableTrim(siteName),
      language: _nullableTrim(language),
    );
    return const Success(null);
  }

  String? _nullableTrim(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}
