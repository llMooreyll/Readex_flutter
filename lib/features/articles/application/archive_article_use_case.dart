import '../domain/article_repository.dart';

final class ArchiveArticleUseCase {
  const ArchiveArticleUseCase({required this.repository});

  final ArticleRepository repository;

  Future<void> archive(int id) => repository.archiveById(id);

  Future<void> unarchive(int id) => repository.unarchiveById(id);
}
