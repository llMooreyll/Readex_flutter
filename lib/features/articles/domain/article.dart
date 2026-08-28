class Article {
  const Article({
    required this.id,
    required this.sourceUrl,
    required this.resolvedUrl,
    required this.title,
    required this.contentHtml,
    required this.contentText,
    required this.estimatedReadingMinutes,
    required this.extractorVersion,
    required this.savedAt,
    required this.updatedAt,
    this.canonicalUrl,
    this.excerpt,
    this.author,
    this.siteName,
    this.language,
    this.publishedAt,
    this.readAt,
    this.archivedAt,
  });

  final int id;
  final String sourceUrl;
  final String resolvedUrl;
  final String? canonicalUrl;
  final String title;
  final String? excerpt;
  final String? author;
  final String? siteName;
  final String? language;
  final DateTime? publishedAt;
  final DateTime? readAt;
  final DateTime? archivedAt;
  final String contentHtml;
  final String contentText;
  final int estimatedReadingMinutes;
  final String extractorVersion;
  final DateTime savedAt;
  final DateTime updatedAt;

  bool get isLinkOnly => extractorVersion.startsWith('link-only/');

  bool get isRead => readAt != null;

  bool get isArchived => archivedAt != null;
}
