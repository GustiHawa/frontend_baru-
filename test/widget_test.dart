import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rumah_nugas/main.dart';

void main() {
  testWidgets('Login screen shows login form', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const RumahNugasApp()); // Remove 'const' here

    // Verify that the login screen is displayed (using a widget text, button, etc.)
    expect(find.text('Rumah Nugas'), findsOneWidget);
    expect(find.byType(TextField),
        findsNWidgets(2)); // Assuming 2 text fields: email and password
    expect(find.byType(ElevatedButton),
        findsOneWidget); // Assuming there is a login button

    // Enter text in the text fields
    await tester.enterText(find.byType(TextField).first, 'test@example.com');
    await tester.enterText(find.byType(TextField).last, 'password123');

    // Tap the login button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(); // Rebuild the widget after the tap

    // After the login button is pressed, verify if we navigate to the user home screen
    expect(
        find.text(
            'Cari dan booking tempat nongkrong dan nugas dengan mudah...'),
        findsOneWidget);
  });
}
