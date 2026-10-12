// Hot reload versus hot restart.
// Run: flutter run -t lib/lecture02_dart/flutter_overview/hot_reload.dart
//
// 1. Tap + a few times.
// 2. Change the text of `label` below, save, press r. The label changes and the counter survives.
// 3. Change `_counter = 0` to `_counter = 100`, save, press r. Nothing changes: the State
//    object already exists, so its field initializer does not run again.
// 4. Press R. The app rebuilds from scratch: the counter starts at 100 and startedAt is new.

import 'package:flutter/material.dart';

// A global: set once when the app starts, so only a hot restart changes it.
final startedAt = DateTime.now();

void main() {
  runApp(const MaterialApp(home: ReloadPage()));
}

class ReloadPage extends StatefulWidget {
  const ReloadPage({super.key});

  @override
  State<ReloadPage> createState() => _ReloadPageState();
}

class _ReloadPageState extends State<ReloadPage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    // build runs again after a hot reload, so a change here shows up at once.
    const label = 'Taps';

    return Scaffold(
      appBar: AppBar(title: const Text('Hot reload versus hot restart')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$label: $_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text('App started at $startedAt'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => _counter++),
        child: const Icon(Icons.add),
      ),
    );
  }
}
