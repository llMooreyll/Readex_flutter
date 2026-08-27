import '../domain/article_repository.dart';

final class DeleteArticleUseCase {
  const DeleteArticleUseCase({required this.repository});

  final ArticleRepository repository;

  Future<void> execute(int id) => repository.deleteById(id);
}
