import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:read_it_later/app/responsive.dart';

void main() {
  Future<void> pumpAtWidth(WidgetTester tester, double width) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(size: Size(width, 800)),
          child: Builder(builder: (context) => Text(context.deviceType.name)),
        ),
      ),
    );
  }

  testWidgets('classifies compact, mobile, tablet, and desktop widths', (
    tester,
  ) async {
    await pumpAtWidth(tester, 320);
    expect(find.text('compact'), findsOneWidget);

    await pumpAtWidth(tester, 400);
    expect(find.text('mobile'), findsOneWidget);

    await pumpAtWidth(tester, 700);
    expect(find.text('tablet'), findsOneWidget);

    await pumpAtWidth(tester, 1000);
    expect(find.text('desktop'), findsOneWidget);
  });

  testWidgets('uses constrained browse and detail specs on large screens', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(size: Size(1200, 800)),
          child: Builder(
            builder: (context) {
              final browse = context.layoutType(ResponsivePageType.browse);
              final detail = context.layoutType(ResponsivePageType.detail);
              return Text('${browse.maxWidth}:${detail.maxWidth}');
            },
          ),
        ),
      ),
    );

    expect(find.text('1120.0:720.0'), findsOneWidget);
  });
}
