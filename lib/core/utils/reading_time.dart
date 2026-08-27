int estimateReadingMinutes(String text) {
  final normalized = text.trim();
  if (normalized.isEmpty) {
    return 1;
  }

  final cjkCharacters = RegExp(r'[\u3400-\u4DBF\u4E00-\u9FFF\uF900-\uFAFF]')
      .allMatches(normalized)
      .length;
  final wordCount = normalized
      .split(RegExp(r'\s+'))
      .where((word) => word.isNotEmpty)
      .length;

  final minutes = cjkCharacters > wordCount
      ? (cjkCharacters / 400).ceil()
      : (wordCount / 200).ceil();
  return minutes < 1 ? 1 : minutes;
}
