import 'package:flutter/material.dart';

enum _Mode { eager, builder, separated }

// ListView, ListView.builder and ListView.separated over the same 10,000 rows.
// The count button reports how many row widgets were created since the last build.
class ListViewsPage extends StatefulWidget {
  const ListViewsPage({super.key});

  @override
  State<ListViewsPage> createState() => _ListViewsPageState();
}

class _ListViewsPageState extends State<ListViewsPage> {
  static const _itemCount = 10000;

  _Mode _mode = _Mode.builder;
  int _created = 0;

  Widget _row(int i) {
    _created++;
    return ListTile(key: ValueKey(i), title: Text('Row $i'));
  }

  @override
  Widget build(BuildContext context) {
    _created = 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ListView'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calculate),
            tooltip: 'Rows created',
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${_mode.name}: $_created rows created')),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: SegmentedButton<_Mode>(
              segments: [
                for (final mode in _Mode.values)
                  ButtonSegment(value: mode, label: Text(mode.name)),
              ],
              selected: {_mode},
              onSelectionChanged: (selected) =>
                  setState(() => _mode = selected.first),
            ),
          ),
          Expanded(
            child: switch (_mode) {
              // Eager: all 10,000 row widgets are created before the first frame.
              _Mode.eager => ListView(
                children: [for (var i = 0; i < _itemCount; i++) _row(i)],
              ),
              // Lazy: itemBuilder runs only for rows near the viewport.
              _Mode.builder => ListView.builder(
                itemCount: _itemCount,
                itemBuilder: (context, i) => _row(i),
              ),
              // The same, with a second builder that runs between items.
              _Mode.separated => ListView.separated(
                itemCount: _itemCount,
                itemBuilder: (context, i) => _row(i),
                separatorBuilder: (context, i) => const Divider(height: 1),
              ),
            },
          ),
        ],
      ),
    );
  }
}
