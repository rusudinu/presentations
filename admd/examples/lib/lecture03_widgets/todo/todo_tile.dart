import 'package:flutter/material.dart';

import 'todo.dart';

// Step 3: the extracted row. Data flows down the constructor, events flow up the callbacks.
class TodoTile extends StatelessWidget {
  const TodoTile({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onRemove,
  });

  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) => ListTile(
    leading: Checkbox(value: todo.done, onChanged: (_) => onToggle()),
    title: Text(todo.title),
    // Lab 3 replaces this button with swipe to delete.
    trailing: IconButton(
      icon: const Icon(Icons.delete_outline),
      tooltip: 'Remove',
      onPressed: onRemove,
    ),
  );
}
