import 'package:flutter/material.dart';

import 'counter_view.dart';
import 'greeting.dart';
import 'stateful_text.dart';
import 'stateless_text.dart';

// StatelessWidget and StatefulWidget side by side.
class StatePage extends StatefulWidget {
  const StatePage({super.key});

  @override
  State<StatePage> createState() => _StatePageState();
}

class _StatePageState extends State<StatePage> {
  static const _names = ['Ada', 'Grace', 'Linus'];
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stateless and stateful')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting has no state, but it rebuilds with a new name when this page rebuilds.
            Greeting(name: _names[_index]),
            FilledButton(
              onPressed: () =>
                  setState(() => _index = (_index + 1) % _names.length),
              child: const Text('Rebuild the parent with the next name'),
            ),
            const Divider(height: 32),
            // CounterView keeps its count while the button above rebuilds the page.
            const CounterView(),
            const Divider(height: 32),
            const StatelessText(),
            const SizedBox(height: 8),
            const StatefulText(), // tap the text to count
          ],
        ),
      ),
    );
  }
}
