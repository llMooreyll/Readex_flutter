import 'package:flutter_test/flutter_test.dart';
import 'package:read_it_later/core/utils/reading_time.dart';

void main() {
  test('returns at least one minute for short text', () {
    expect(estimateReadingMinutes('A short article.'), 1);
    expect(estimateReadingMinutes(''), 1);
  });

  test('uses a CJK character estimate for CJK text', () {
    final text = List.filled(401, '文').join();

    expect(estimateReadingMinutes(text), 2);
  });

  test('uses a word estimate for whitespace-separated text', () {
    final text = List.filled(201, 'word').join(' ');

    expect(estimateReadingMinutes(text), 2);
  });
}
