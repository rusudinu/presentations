import 'package:flutter/material.dart';

// setState marks one element dirty, and only that subtree rebuilds.
class RebuildScopePage extends StatelessWidget {
  const RebuildScopePage({super.key});

  // Counts builds for the demo. Real widgets keep no mutable static state.
  static int _pageBuilds = 0;

  @override
  Widget build(BuildContext context) {
    _pageBuilds++;
    return Scaffold(
      appBar: AppBar(title: const Text('Rebuild scope')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // This number does not move when a button below is tapped.
            Text('The page was built $_pageBuilds times'),
            const SizedBox(height: 16),
            const _CountingButton(label: 'Left'),
            const _CountingButton(label: 'Right'),
          ],
        ),
      ),
    );
  }
}

class _CountingButton extends StatefulWidget {
  const _CountingButton({required this.label});

  final String label;

  @override
  State<_CountingButton> createState() => _CountingButtonState();
}

class _CountingButtonState extends State<_CountingButton> {
  int _builds = 0;

  @override
  Widget build(BuildContext context) {
    _builds++;
    return OutlinedButton(
      onPressed: () => setState(() {}),
      child: Text('${widget.label}: built $_builds times'),
    );
  }
}
