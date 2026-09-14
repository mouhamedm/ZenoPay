import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zenopay/app.dart';

void main() {
  testWidgets('Zeno Pay app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ZenoPayApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
