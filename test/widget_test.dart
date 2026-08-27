import 'package:flutter_test/flutter_test.dart';

import 'package:read_it_later/main.dart';

void main() {
  testWidgets('app bootstrap renders the product name', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ReadItLaterApp());

    expect(find.text('稍后读'), findsOneWidget);
    expect(find.text('应用基础环境已就绪'), findsOneWidget);
  });
}
