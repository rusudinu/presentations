import 'package:flutter/material.dart';

// On rebuild, new widgets are matched to existing elements by runtime type, then by key.
// Tick the first row, then remove it. Without keys the tick stays at position 0 and lands on
// the next item. With a ValueKey the State follows the item and leaves with it.
class KeysPage extends StatefulWidget {
  const KeysPage({super.key});

  @override
  State<KeysPage> createState() => _KeysPageState();
}

class _KeysPageState extends State<KeysPage> {
  static const _all = [(1, 'Buy milk'), (2, 'Write lab 3'), (3, 'Call home')];

  List<(int, String)> _items = List.of(_all);
  bool _useKeys = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Keys')),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text('Give each row a ValueKey'),
            // Switching changes every key, so no element matches and the ticks reset.
            value: _useKeys,
            onChanged: (value) => setState(() => _useKeys = value),
          ),
          for (final (id, title) in _items)
            _TickRow(key: _useKeys ? ValueKey(id) : null, title: title),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: [
              FilledButton(
                onPressed: _items.isEmpty
                    ? null
                    : () => setState(() => _items.removeAt(0)),
                child: const Text('Remove the first row'),
              ),
              OutlinedButton(
                onPressed: () => setState(() => _items = List.of(_all)),
                child: const Text('Reset'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// The tick lives in this row's State, not in the data.
class _TickRow extends StatefulWidget {
  const _TickRow({super.key, required this.title});

  final String title;

  @override
  State<_TickRow> createState() => _TickRowState();
}

class _TickRowState extends State<_TickRow> {
  bool _ticked = false;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(widget.title),
      value: _ticked,
      onChanged: (value) => setState(() => _ticked = value ?? false),
    );
  }
}
