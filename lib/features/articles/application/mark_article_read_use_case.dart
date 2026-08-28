import '../domain/article_repository.dart';

final class MarkArticleReadUseCase {
  const MarkArticleReadUseCase({required this.repository});

  final ArticleRepository repository;

  Future<void> markAsRead(int id) => repository.markAsRead(id);

  Future<void> markAsUnread(int id) => repository.markAsUnread(id);
}
