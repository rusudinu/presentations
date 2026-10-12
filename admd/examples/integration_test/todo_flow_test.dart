// An integration test: the same API as a widget test, on a real device or emulator,
// with the whole app, its plugins and real frames.
// Run: flutter test integration_test   (with a device booted)
import 'package:flutter/material.dart';
import 'package:flutter_examples/lecture14_polish/main.dart';
import 'package:flutter_examples/lecture14_polish/testing/todo_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('open the todo screen from the list and add a todo', (
    tester,
  ) async {
    await tester.pumpWidget(const Lecture14App());

    await tester.scrollUntilVisible(find.text('The screen under test'), 200);
    await tester.tap(find.text('The screen under test'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Buy milk');
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.byType(TodoTile), findsOneWidget);
    expect(find.text('Buy milk'), findsOneWidget);
  });
}
