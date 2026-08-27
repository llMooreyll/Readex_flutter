import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:read_it_later/app/providers.dart';
import 'package:read_it_later/features/articles/domain/article.dart';
import 'package:read_it_later/features/articles/presentation/pages/reader_page.dart';

void main() {
  Article article({required bool linkOnly}) {
    return Article(
      id: 7,
      sourceUrl: 'https://example.com/story',
      resolvedUrl: 'https://example.com/story',
      title: 'Reader test article',
      contentHtml: linkOnly
          ? ''
          : '<h2>Section heading</h2><p>${'Readable article text. ' * 4}</p>'
                '<blockquote>Quoted text</blockquote>',
      contentText: linkOnly ? '' : 'Readable article text. ' * 4,
      estimatedReadingMinutes: linkOnly ? 0 : 1,
      extractorVersion: linkOnly ? 'link-only/1.0' : 'reader_mode/0.2.2',
      savedAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026),
    );
  }

  testWidgets('renders rich article content', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          articleByIdProvider(7)
              .overrideWith((ref) async => article(linkOnly: false)),
        ],
        child: const MaterialApp(home: ReaderPage(id: 7)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Reader test article'), findsNWidgets(2));
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is RichText &&
            widget.text.toPlainText().contains('Section heading'),
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is RichText &&
            widget.text.toPlainText().contains('Quoted text'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('renders browser action for link-only article', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          articleByIdProvider(7)
              .overrideWith((ref) async => article(linkOnly: true)),
        ],
        child: const MaterialApp(home: ReaderPage(id: 7)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Saved link'), findsOneWidget);
    expect(find.text('Open in browser'), findsOneWidget);
  });
}
