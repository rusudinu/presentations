import 'package:flutter/material.dart';

// RenderFlex overflow: a child asks for more room than the Row can give it.
class OverflowPage extends StatefulWidget {
  const OverflowPage({super.key});

  @override
  State<OverflowPage> createState() => _OverflowPageState();
}

class _OverflowPageState extends State<OverflowPage> {
  static const _veryLongDisplayName =
      'Augusta Ada King, Countess of Lovelace, author of the first published program';

  bool _showBroken = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RenderFlex overflow errors')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Show the broken Row'),
            subtitle: const Text('Read the stripes, then the console'),
            value: _showBroken,
            onChanged: (value) => setState(() => _showBroken = value),
          ),
          if (_showBroken)
            // Breaks: the Text asks for more width than the Row can give it.
            const Row(
              children: [Icon(Icons.person), Text(_veryLongDisplayName)],
            ),
          const Divider(height: 32),
          const Text('Fix 1: Expanded gives the Text a share, so it wraps'),
          const Row(
            children: [
              Icon(Icons.person),
              Expanded(child: Text(_veryLongDisplayName)),
            ],
          ),
          const Divider(height: 32),
          const Text('Fix 2: one line with an ellipsis'),
          const Row(
            children: [
              Icon(Icons.person),
              Expanded(
                child: Text(
                  _veryLongDisplayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Divider(height: 32),
          const Text('Fix 3: make the Row scroll'),
          const SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [Icon(Icons.person), Text(_veryLongDisplayName)],
            ),
          ),
        ],
      ),
    );
  }
}
