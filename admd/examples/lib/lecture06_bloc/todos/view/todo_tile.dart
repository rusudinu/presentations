import 'package:flutter/material.dart';

import '../data/todo.dart';

// Knows nothing about blocs: data down the constructor, events up the callback.
class TodoTile extends StatelessWidget {
  const TodoTile(this.todo, {super.key, this.onToggle});

  final Todo todo;
  final VoidCallback? onToggle;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(todo.title),
      value: todo.done,
      onChanged: onToggle == null ? null : (_) => onToggle!(),
    );
  }
}
