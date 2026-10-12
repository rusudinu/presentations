// pump and pumpAndSettle on a form that validates, waits for a server, and reports.
import 'package:flutter/material.dart';
import 'package:flutter_examples/lecture14_polish/forms/sign_in_form_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> fill(WidgetTester tester, String email, String password) async {
    await tester.pumpWidget(const MaterialApp(home: SignInFormPage()));
    await tester.enterText(find.widgetWithText(TextFormField, 'Email'), email);
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Password'),
      password,
    );
  }

  testWidgets('validation messages appear under the fields', (tester) async {
    await fill(tester, 'ana.example.com', 'short');

    await tester.tap(find.byType(FilledButton));
    await tester
        .pump(); // one frame: the validators ran, the messages are built

    expect(find.text('This address is missing an @'), findsOneWidget);
    expect(find.text('Use at least 8 characters'), findsOneWidget);
  });

  testWidgets('the button is disabled while the request runs', (tester) async {
    await fill(tester, 'ana@example.com', 'long enough');

    await tester.tap(find.byType(FilledButton));
    await tester.pump(); // one frame: the request has started
    expect(find.text('Signing in'), findsOneWidget);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).enabled,
      isFalse,
    );

    // Advance the clock past the 1 s request. Time in a widget test moves only when pumped.
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Sign in'), findsOneWidget);

    // The SnackBar slides in over several frames. pumpAndSettle pumps until
    // no frame is scheduled, so the entrance animation is over when it returns.
    await tester.pumpAndSettle();
    expect(find.text('Signed in'), findsOneWidget);
  });

  testWidgets('a server error is shown and the fields keep their text', (
    tester,
  ) async {
    await fill(tester, 'taken@example.com', 'long enough');

    await tester.tap(find.byType(FilledButton));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    expect(find.text('Error: Email already registered'), findsOneWidget);
    expect(find.text('taken@example.com'), findsOneWidget);
  });
}
