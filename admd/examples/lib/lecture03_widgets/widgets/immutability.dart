import 'package:flutter/material.dart';

// A const widget is canonicalized: every build gets the same instance.
// Without const, every build allocates a new one.
class ImmutabilityPage extends StatefulWidget {
  const ImmutabilityPage({super.key});

  @override
  State<ImmutabilityPage> createState() => _ImmutabilityPageState();
}

class _ImmutabilityPageState extends State<ImmutabilityPage> {
  int _builds = 0;
  Widget _previousConst = _constTitle();
  Widget _previousNew = _newTitle();

  static Widget _constTitle() => const Text('Todos');

  // ignore: prefer_const_constructors -- a new instance per call is the point here
  static Widget _newTitle() => Text('Todos');

  @override
  Widget build(BuildContext context) {
    final constTitle = _constTitle();
    final newTitle = _newTitle();
    final constReused = identical(constTitle, _previousConst);
    final newReused = identical(newTitle, _previousNew);
    _previousConst = constTitle;
    _previousNew = newTitle;
    _builds++;

    return Scaffold(
      appBar: AppBar(title: const Text('Widget immutability')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Build number $_builds'),
            const SizedBox(height: 12),
            Text("const Text('Todos') is last build's instance: $constReused"),
            Text("Text('Todos') is last build's instance: $newReused"),
            const SizedBox(height: 12),
            // A widget's fields are final. To change the screen, build a new description.
            FilledButton(
              onPressed: () => setState(() {}),
              child: const Text('Rebuild'),
            ),
          ],
        ),
      ),
    );
  }
}
