import 'package:flutter/material.dart';

import 'todo.dart';
import 'todo_tile.dart';

// The worked example from Part 5: the Lab 3 todo screen, steps 1 to 5.
// The screen is stateful because the list changes while the screen is on the tree.
class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final _todos = <Todo>[];
  int _nextId = 0;

  // Step 4: mutate, then setState. Change the list outside the callback
  // and the screen never updates.
  void _add(String title) {
    final todo = Todo(_nextId++, title);
    setState(() => _todos.add(todo));
  }

  void _toggle(Todo todo) => setState(() => todo.done = !todo.done);

  void _remove(Todo todo) {
    setState(() => _todos.remove(todo));
    // Step 5: report what already happened.
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Removed')));
  }

  Future<void> _askForTitle() async {
    final title = await showDialog<String>(
      context: context,
      builder: (_) => const _NewTodoDialog(),
    );
    if (!mounted) return;
    if (title != null && title.trim().isNotEmpty) _add(title.trim());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Todos')),
    // Step 5: the empty state is part of the design.
    body: _todos.isEmpty
        ? const Center(child: Text('Nothing to do yet.'))
        // Step 2: a builder, because the list grows with the data.
        : ListView.builder(
            itemCount: _todos.length,
            itemBuilder: (context, i) => TodoTile(
              // The ValueKey ties State to the todo, not to the row position.
              key: ValueKey(_todos[i].id),
              todo: _todos[i],
              onToggle: () => _toggle(_todos[i]),
              onRemove: () => _remove(_todos[i]),
            ),
          ),
    floatingActionButton: FloatingActionButton(
      onPressed: _askForTitle,
      tooltip: 'Add a todo',
      child: const Icon(Icons.add),
    ),
  );
}

class _NewTodoDialog extends StatefulWidget {
  const _NewTodoDialog();

  @override
  State<_NewTodoDialog> createState() => _NewTodoDialogState();
}

class _NewTodoDialogState extends State<_NewTodoDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New todo'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(hintText: 'Title'),
        onSubmitted: (value) => Navigator.of(context).pop(value),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_controller.text),
          child: const Text('Add'),
        ),
      ],
    );
  }
}
