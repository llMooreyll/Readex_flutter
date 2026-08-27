class ArticleListItem {
  const ArticleListItem({
    required this.id,
    required this.title,
    required this.sourceUrl,
    required this.excerpt,
    required this.author,
    required this.siteName,
    required this.estimatedReadingMinutes,
    required this.savedAt,
  });

  final int id;
  final String title;
  final String sourceUrl;
  final String? excerpt;
  final String? author;
  final String? siteName;
  final int estimatedReadingMinutes;
  final DateTime savedAt;
}
