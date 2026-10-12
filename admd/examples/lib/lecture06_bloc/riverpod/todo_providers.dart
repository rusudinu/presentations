import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../todos/data/todo.dart';
import '../todos/data/todo_api.dart';
import '../todos/data/todo_repository.dart';

// Providers are top-level values, looked up by reference. No BuildContext is involved,
// and a provider that does not exist is a compile error.
final repoProvider = Provider((ref) => TodoRepository(TodoApi()));

// The Riverpod counterpart of a Cubit: a class that owns one piece of state.
class TodoListNotifier extends Notifier<List<Todo>> {
  @override
  List<Todo> build() => const [];

  // Assigning a new list is what notifies the listeners.
  void add(Todo todo) => state = [...state, todo];

  void toggle(String id) => state = [
    for (final t in state)
      if (t.id == id) t.copyWith(done: !t.done) else t,
  ];

  // Providers read each other through ref.
  Future<void> load() async {
    state = await ref.read(repoProvider).fetchTodos();
  }
}

final todoListProvider = NotifierProvider<TodoListNotifier, List<Todo>>(
  TodoListNotifier.new,
);

// A provider derived from another one. It recomputes when the list changes.
final openCountProvider = Provider(
  (ref) => ref.watch(todoListProvider).where((t) => !t.done).length,
);
