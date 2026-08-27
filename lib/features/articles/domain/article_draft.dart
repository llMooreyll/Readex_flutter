class ArticleDraft {
  const ArticleDraft({
    required this.sourceUrl,
    required this.resolvedUrl,
    required this.title,
    required this.contentHtml,
    required this.contentText,
    required this.estimatedReadingMinutes,
    required this.extractorVersion,
    this.canonicalUrl,
    this.excerpt,
    this.author,
    this.siteName,
    this.language,
    this.publishedAt,
  });

  final String sourceUrl;
  final String resolvedUrl;
  final String? canonicalUrl;
  final String title;
  final String? excerpt;
  final String? author;
  final String? siteName;
  final String? language;
  final DateTime? publishedAt;
  final String contentHtml;
  final String contentText;
  final int estimatedReadingMinutes;
  final String extractorVersion;
}
