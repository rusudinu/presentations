// Lecture 3, Widgets and layout: one screen per slide topic, opened from a list.
// Run: flutter run -t lib/lecture03_widgets/main.dart

import 'package:flutter/material.dart';

import 'layout/constraints.dart';
import 'layout/expanded_and_flexible.dart';
import 'layout/overflow.dart';
import 'layout/padding_sizedbox_container.dart';
import 'layout/row_and_column.dart';
import 'layout/stack_positioned_align.dart';
import 'material/buttons.dart';
import 'material/cupertino_and_adaptive.dart';
import 'material/scaffold.dart';
import 'material/snackbars_and_dialogs.dart';
import 'scrolling/custom_scroll_view.dart';
import 'scrolling/grid_view.dart';
import 'scrolling/list_views.dart';
import 'scrolling/single_child_scroll_view.dart';
import 'state/state_page.dart';
import 'todo/todo_page.dart';
import 'widgets/composition_wrapping.dart';
import 'widgets/extracting_widgets.dart';
import 'widgets/immutability.dart';
import 'widgets/keys.dart';
import 'widgets/rebuild_scope.dart';
import 'widgets/widget_kinds.dart';

void main() {
  runApp(const Lecture03App());
}

// (part, title, screen). The order follows the slides.
const _examples = <(String, String, Widget)>[
  ('Part 1 · Widgets', 'Everything is a widget', WidgetKindsPage()),
  ('Part 1 · Widgets', 'Widget immutability', ImmutabilityPage()),
  (
    'Part 1 · Widgets',
    'Composition over inheritance',
    CompositionWrappingPage(),
  ),
  ('Part 1 · Widgets', 'Stateless and stateful', StatePage()),
  ('Part 1 · Widgets', 'Rebuild scope', RebuildScopePage()),
  ('Part 1 · Widgets', 'Keys', KeysPage()),
  ('Part 1 · Widgets', 'Extracting widgets', ExtractingWidgetsPage()),
  ('Part 2 · Layout', 'Layout constraints', ConstraintsPage()),
  (
    'Part 2 · Layout',
    'Padding, SizedBox and Container',
    PaddingSizedBoxContainerPage(),
  ),
  ('Part 2 · Layout', 'Row and Column', RowAndColumnPage()),
  ('Part 2 · Layout', 'Expanded and Flexible', ExpandedAndFlexiblePage()),
  (
    'Part 2 · Layout',
    'Stack, Positioned and Align',
    StackPositionedAlignPage(),
  ),
  ('Part 2 · Layout', 'RenderFlex overflow errors', OverflowPage()),
  ('Part 3 · Scrolling', 'ListView and ListView.builder', ListViewsPage()),
  ('Part 3 · Scrolling', 'GridView', GridViewPage()),
  ('Part 3 · Scrolling', 'SingleChildScrollView', SingleChildScrollViewPage()),
  ('Part 3 · Scrolling', 'CustomScrollView', CustomScrollViewPage()),
  ('Part 4 · Material', 'Scaffold', ScaffoldPage()),
  ('Part 4 · Material', 'Buttons', ButtonsPage()),
  ('Part 4 · Material', 'SnackBars and dialogs', SnackBarsAndDialogsPage()),
  (
    'Part 4 · Material',
    'Cupertino and adaptive widgets',
    CupertinoAndAdaptivePage(),
  ),
  ('Part 5 · Worked example', 'Lab 3 todo screen', TodoPage()),
];

class Lecture03App extends StatelessWidget {
  const Lecture03App({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp supplies the theme, the text direction and the navigator.
    return MaterialApp(
      title: 'Lecture 3',
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      home: const ExamplesPage(),
    );
  }
}

class ExamplesPage extends StatelessWidget {
  const ExamplesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lecture 3: Widgets and layout')),
      body: ListView.builder(
        itemCount: _examples.length,
        itemBuilder: (context, i) {
          final (part, title, screen) = _examples[i];
          final startsPart = i == 0 || _examples[i - 1].$1 != part;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (startsPart)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                  child: Text(
                    part,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ListTile(
                title: Text(title),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(
                  context,
                ).push(MaterialPageRoute<void>(builder: (_) => screen)),
              ),
            ],
          );
        },
      ),
    );
  }
}
