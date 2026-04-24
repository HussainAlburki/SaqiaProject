import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saqia/app.dart';

void main() {
  testWidgets('App boots and shows splash branding', (WidgetTester tester) async {
    await tester.pumpWidget(const SaqiaApp());
    await tester.pump(const Duration(milliseconds: 150));
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('Saqia'), findsOneWidget);
  });
}
