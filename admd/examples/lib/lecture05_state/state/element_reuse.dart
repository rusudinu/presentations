import 'package:flutter/material.dart';

// Element reuse: same runtimeType and same key keeps the Element and its State.
// Tick a row, then reorder or delete. Without keys the tick stays at its position.
class ElementReusePage extends StatefulWidget {
  const ElementReusePage({super.key});

  @override
  State<ElementReusePage> createState() => _ElementReusePageState();
}

class _ElementReusePageState extends State<ElementReusePage> {
  static const _all = [(1, 'Buy milk'), (2, 'Write lab 5'), (3, 'Call home')];

  List<(int, String)> _todos = List.of(_all);
  bool _useKeys = false;
  bool _compact = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Element reuse')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Give each row a ValueKey(todo.id)'),
            value: _useKeys,
            onChanged: (value) => setState(() => _useKeys = value),
          ),
          SwitchListTile(
            title: const Text('Use a different widget class for the rows'),
            subtitle: const Text('A new runtimeType disposes every State'),
            value: _compact,
            onChanged: (value) => setState(() => _compact = value),
          ),
          for (final (id, title) in _todos)
            if (_compact)
              _CompactTodoTile(
                key: _useKeys ? ValueKey(id) : null,
                title: title,
              )
            else
              _TodoTile(key: _useKeys ? ValueKey(id) : null, title: title),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton(
                  onPressed: () =>
                      setState(() => _todos = _todos.reversed.toList()),
                  child: const Text('Reverse the order'),
                ),
                FilledButton(
                  onPressed: _todos.isEmpty
                      ? null
                      : () => setState(() => _todos.removeAt(0)),
                  child: const Text('Delete the first'),
                ),
                OutlinedButton(
                  onPressed: () => setState(() => _todos = List.of(_all)),
                  child: const Text('Reset'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// The tick is ephemeral state: it lives in the row's State, not in the data.
class _TodoTile extends StatefulWidget {
  const _TodoTile({super.key, required this.title});

  final String title;

  @override
  State<_TodoTile> createState() => _TodoTileState();
}

class _TodoTileState extends State<_TodoTile> {
  bool _ticked = false;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      // widget.title is refreshed by the framework when the Element is reused.
      title: Text(widget.title),
      value: _ticked,
      onChanged: (value) => setState(() => _ticked = value ?? false),
    );
  }
}

class _CompactTodoTile extends StatefulWidget {
  const _CompactTodoTile({super.key, required this.title});

  final String title;

  @override
  State<_CompactTodoTile> createState() => _CompactTodoTileState();
}

class _CompactTodoTileState extends State<_CompactTodoTile> {
  bool _ticked = false;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      dense: true,
      title: Text(widget.title),
      value: _ticked,
      onChanged: (value) => setState(() => _ticked = value ?? false),
    );
  }
}
