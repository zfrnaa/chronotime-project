// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chronotime_project/main.dart'; // Adjust based on your project structure
import 'package:chronotime_project/core/login.dart';

void main() {
  testWidgets('Firebase initializes and navigates to LoginPage', (WidgetTester tester) async {
    // Build the widget tree
    await tester.pumpWidget(const MyApp());

    // Wait for Firebase initialization (simulate async behavior)
    await tester.pumpAndSettle();

    // Verify if LoginPage is shown after Firebase initializes
    expect(find.byType(LoginPage), findsOneWidget);
  });
}
