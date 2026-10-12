import 'package:flutter/material.dart';

// Padding and SizedBox do one job each. Container bundles several widgets.
class PaddingSizedBoxContainerPage extends StatelessWidget {
  const PaddingSizedBoxContainerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final card = Theme.of(context).colorScheme.primaryContainer;

    return Scaffold(
      appBar: AppBar(title: const Text('Padding, SizedBox and Container')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reach for these two first.
          const Padding(padding: EdgeInsets.all(16), child: Text('Todos')),
          const SizedBox(height: 12), // a gap
          // Container wraps Padding, DecoratedBox, ConstrainedBox and Align in one constructor.
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: card),
            child: const Text('Todos'),
          ),
          const SizedBox(height: 12),
          // The same box, written as the widgets Container builds for you.
          DecoratedBox(
            decoration: BoxDecoration(color: card),
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Text('Todos'),
            ),
          ),
          const SizedBox(height: 12),
          // SizedBox with a child imposes a size on it.
          const SizedBox(
            width: 160,
            height: 48,
            child: ColoredBox(
              color: Colors.amber,
              child: Center(child: Text('160 x 48')),
            ),
          ),
        ],
      ),
    );
  }
}
