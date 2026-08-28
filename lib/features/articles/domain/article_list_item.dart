class ArticleListItem {
  const ArticleListItem({
    required this.id,
    required this.title,
    required this.sourceUrl,
    required this.excerpt,
    required this.author,
    required this.siteName,
    required this.estimatedReadingMinutes,
    required this.isLinkOnly,
    required this.readAt,
    required this.archivedAt,
    required this.savedAt,
  });

  final int id;
  final String title;
  final String sourceUrl;
  final String? excerpt;
  final String? author;
  final String? siteName;
  final int estimatedReadingMinutes;
  final bool isLinkOnly;
  final DateTime? readAt;
  final DateTime? archivedAt;
  final DateTime savedAt;

  bool get isRead => readAt != null;

  bool get isArchived => archivedAt != null;
}
