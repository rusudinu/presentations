// Lecture 4, Async Dart: one screen per slide that has a widget in it.
// Run: flutter run -t lib/lecture04_async/main.dart
// The console examples are under futures/ and streams/: make list shows them.

import 'package:flutter/material.dart';

import 'ui/future_and_stream.dart';
import 'ui/future_builder.dart';
import 'ui/future_in_build.dart';
import 'ui/heavy_work.dart';
import 'ui/refresh_with_errors.dart';
import 'ui/stream_builder.dart';

void main() {
  runApp(const Lecture04App());
}

// (title, screen). The order follows the slides.
const _examples = <(String, Widget)>[
  ('Handling errors around await', RefreshWithErrorsPage()),
  ('FutureBuilder', FutureBuilderPage()),
  ('Creating the Future outside build', FutureInBuildPage()),
  ('StreamBuilder', StreamBuilderPage()),
  ('Combining a Future and a Stream', FutureAndStreamPage()),
  ('compute() for heavy work', HeavyWorkPage()),
];

class Lecture04App extends StatelessWidget {
  const Lecture04App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lecture 4',
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
      appBar: AppBar(title: const Text('Lecture 4: Async Dart')),
      body: ListView(
        children: [
          for (final (title, screen) in _examples)
            ListTile(
              title: Text(title),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(
                context,
              ).push(MaterialPageRoute<void>(builder: (_) => screen)),
            ),
        ],
      ),
    );
  }
}
