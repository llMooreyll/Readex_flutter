import '../domain/article_repository.dart';
import '../domain/article.dart';

final class DeleteArticleUseCase {
  const DeleteArticleUseCase({required this.repository});

  final ArticleRepository repository;

  Future<Article?> execute(int id) async {
    final article = await repository.getById(id);
    if (article == null) {
      return null;
    }
    await repository.deleteById(id);
    return article;
  }

  Future<void> undo(Article article) => repository.restore(article);
}
