import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:read_it_later/app/app.dart';
import 'package:read_it_later/app/providers.dart';

void main() {
  testWidgets('app bootstrap renders the product name', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          articleListProvider.overrideWith((ref) => Stream.value(const [])),
        ],
        child: const ReadItLaterApp(),
      ),
    );

    expect(find.text('Read It Later'), findsOneWidget);
  });
}
