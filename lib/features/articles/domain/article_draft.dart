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

  ArticleDraft withMetadata({
    required String title,
    required String? excerpt,
    required String? author,
    required String? siteName,
    required String? language,
  }) {
    return ArticleDraft(
      sourceUrl: sourceUrl,
      resolvedUrl: resolvedUrl,
      canonicalUrl: canonicalUrl,
      title: title.trim(),
      excerpt: _nullableTrim(excerpt),
      author: _nullableTrim(author),
      siteName: _nullableTrim(siteName),
      language: _nullableTrim(language),
      publishedAt: publishedAt,
      contentHtml: contentHtml,
      contentText: contentText,
      estimatedReadingMinutes: estimatedReadingMinutes,
      extractorVersion: extractorVersion,
    );
  }

  String? _nullableTrim(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}
