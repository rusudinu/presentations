import 'package:flutter/material.dart';

// Expanded and Flexible divide the space left after the fixed children are sized.
class ExpandedAndFlexiblePage extends StatelessWidget {
  const ExpandedAndFlexiblePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expanded and Flexible')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Expanded and Expanded(flex: 2)'),
            Row(
              children: [
                Icon(Icons.person),
                SizedBox(width: 8),
                // Takes one share of the leftover width.
                Expanded(child: _Box('flex: 1', Colors.amber)),
                // Takes twice as much as flex: 1.
                Expanded(flex: 2, child: _Box('flex: 2', Colors.lightBlue)),
              ],
            ),
            SizedBox(height: 24),
            Text('Expanded forces the child to fill its share'),
            Row(
              children: [
                Expanded(child: _Box('short', Colors.amber)),
                Expanded(child: _Box('short', Colors.lightBlue)),
              ],
            ),
            SizedBox(height: 24),
            Text('Flexible allows a smaller child'),
            Row(
              children: [
                Flexible(child: _Box('short', Colors.amber)),
                Flexible(child: _Box('short', Colors.lightBlue)),
              ],
            ),
            // Both work only as a direct child of a Row, Column or Flex.
            // An Expanded inside a Stack throws "Incorrect use of ParentDataWidget".
          ],
        ),
      ),
    );
  }
}

class _Box extends StatelessWidget {
  const _Box(this.label, this.color);

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: color,
      child: Padding(padding: const EdgeInsets.all(12), child: Text(label)),
    );
  }
}
