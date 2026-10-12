// Lecture 5, State management part 1: one screen per slide topic.
// Run: flutter run -t lib/lecture05_state/main.dart
// Open DevTools on it for Part 1: Inspector, Performance, Rebuild Stats.

import 'package:flutter/material.dart';

import 'counter.dart';
import 'debugging/jank.dart';
import 'debugging/logging.dart';
import 'debugging/performance_overlay.dart';
import 'parent_child/parent_widget.dart';
import 'sharing/inherited_widget.dart';
import 'sharing/lifting_state_up.dart';
import 'sharing/prop_drilling.dart';
import 'sharing/value_equality_rebuilds.dart';
import 'state/element_reuse.dart';
import 'state/lifecycle.dart';
import 'state/set_state_scope.dart';

void main() {
  runApp(const Lecture05App());
}

// (part, title, screen). The order follows the slides.
const _examples = <(String, String, Widget)>[
  ('Part 1 · Debugging', 'print, debugPrint, and assert', LoggingPage()),
  ('Part 1 · Debugging', 'Frames and jank', JankPage()),
  ('Part 2 · State', 'A counter with setState', _Wrapped('Counter', Counter())),
  ('Part 2 · State', 'setState in detail', SetStateScopePage()),
  ('Part 2 · State', 'Element reuse', ElementReusePage()),
  ('Part 2 · State', 'State object rules', LifecyclePage()),
  (
    'Part 3 · Sharing state',
    'Parent and child',
    _Wrapped('Parent and child', Center(child: ParentWidget())),
  ),
  ('Part 3 · Sharing state', 'Lifting state up', LiftingStateUpPage()),
  ('Part 3 · Sharing state', 'Lifting state up: the cost', PropDrillingPage()),
  ('Part 3 · Sharing state', 'InheritedWidget', InheritedWidgetPage()),
  (
    'Part 3 · Sharing state',
    'Value equality and rebuilds',
    ValueEqualityRebuildsPage(),
  ),
];

class Lecture05App extends StatelessWidget {
  const Lecture05App({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: showPerformanceOverlay,
      builder: (context, overlay, _) => MaterialApp(
        title: 'Lecture 5',
        showPerformanceOverlay: overlay,
        theme: ThemeData(colorSchemeSeed: Colors.indigo),
        home: const ExamplesPage(),
      ),
    );
  }
}

class ExamplesPage extends StatelessWidget {
  const ExamplesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lecture 5: State management, part 1')),
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

// Gives the older examples, which are bare widgets, a screen to sit in.
class _Wrapped extends StatelessWidget {
  const _Wrapped(this.title, this.child);

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: child,
    );
  }
}
