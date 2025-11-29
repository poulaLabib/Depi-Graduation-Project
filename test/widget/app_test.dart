import 'package:depi_graduation_project/fikraty.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App should render without crashing', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const Fikraty());

    // Verify that the app renders without throwing any exceptions
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
