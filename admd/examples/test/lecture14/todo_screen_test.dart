// Widget tests: a headless tree, driven with find, tap and pump.
import 'package:flutter/material.dart';
import 'package:flutter_examples/lecture14_polish/testing/todo_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('adding a todo shows it in the list', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: TodoScreen()));

    await tester.enterText(find.byType(TextField), 'Buy milk');
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump(); // build one new frame

    expect(find.text('Buy milk'), findsOneWidget);
    expect(find.byType(TodoTile), findsNWidgets(1));
  });

  testWidgets('an empty title adds nothing', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: TodoScreen()));

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.byType(TodoTile), findsNothing);
  });

  // The add button has a tooltip, which is its screen reader label.
  testWidgets('the add button is labeled', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: TodoScreen()));

    expect(find.byTooltip('Add todo'), findsOneWidget);
  });
}
