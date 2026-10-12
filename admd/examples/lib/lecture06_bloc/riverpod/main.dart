// The todo list with Riverpod, for comparison with todos/. The course uses flutter_bloc.
// One app runs one state management package: this is a separate entry point for that reason.
// Run: flutter run -t lib/lecture06_bloc/riverpod/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../todos/data/todo.dart';
import '../todos/view/todo_tile.dart';
import 'todo_providers.dart';

// ProviderScope holds the state of every provider.
void main() => runApp(const ProviderScope(child: App()));

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todos with Riverpod',
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      home: const TodoPage(),
    );
  }
}

// A ConsumerWidget gets a WidgetRef in build, where a bloc widget would use context.
class TodoPage extends ConsumerWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final open = ref.watch(openCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Todos: $open open'),
        actions: [
          IconButton(
            tooltip: 'Load from the repository',
            icon: const Icon(Icons.refresh),
            // ref.read in callbacks, ref.watch in build: the same rule as context.read and watch.
            onPressed: () => ref.read(todoListProvider.notifier).load(),
          ),
        ],
      ),
      body: const TodoList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final notifier = ref.read(todoListProvider.notifier);
          final id = '${ref.read(todoListProvider).length + 1}';
          notifier.add(Todo(id: id, title: 'Todo $id'));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TodoList extends ConsumerWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoListProvider);
    return ListView(
      children: [
        for (final t in todos)
          TodoTile(
            t,
            key: ValueKey(t.id),
            onToggle: () => ref.read(todoListProvider.notifier).toggle(t.id),
          ),
      ],
    );
  }
}
