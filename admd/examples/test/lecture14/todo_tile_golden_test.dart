// Golden tests: render a widget, compare it with a reference image pixel by pixel.
// Create or update the image with: flutter test --update-goldens test/lecture14
// Review goldens/todo_tile.png in the pull request like any other change.
import 'package:flutter/material.dart';
import 'package:flutter_examples/lecture14_polish/testing/todo_screen.dart';
import 'package:flutter_examples/lecture14_polish/theming/app_theme.dart';
import 'package:flutter_test/flutter_test.dart';

// A fixed theme and a fixed width, so the image depends on nothing but the widget.
Widget wrap(Widget child) => MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: appTheme(Brightness.light),
  home: Scaffold(
    body: Center(child: SizedBox(width: 320, child: child)),
  ),
);

void main() {
  testWidgets('TodoTile matches its golden', (tester) async {
    await tester.pumpWidget(wrap(const TodoTile(title: 'Buy milk')));

    await expectLater(
      find.byType(TodoTile),
      matchesGoldenFile('goldens/todo_tile.png'),
    );
  });
}
