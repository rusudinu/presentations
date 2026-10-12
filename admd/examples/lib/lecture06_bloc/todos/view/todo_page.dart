import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth/auth_cubit.dart';
import '../bloc/todo_bloc.dart';
import '../data/todo_api.dart';
import 'add_todo_page.dart';
import 'todo_tile.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key, required this.user});

  final String user;

  void _openAddPage(BuildContext context) {
    // A new route sits beside this page in the tree, not below it, so the bloc
    // is handed over. value reuses the instance and does not close it.
    final bloc = context.read<TodoBloc>();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            BlocProvider.value(value: bloc, child: const AddTodoPage()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const _OpenCount(),
        actions: [
          IconButton(
            tooltip: 'Reload',
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                context.read<TodoBloc>().add(const TodosRequested()),
          ),
          IconButton(
            tooltip: 'Reload with a failure',
            icon: const Icon(Icons.cloud_off),
            onPressed: () {
              context.read<TodoApi>().failNextRequest = true;
              context.read<TodoBloc>().add(const TodosRequested());
            },
          ),
          IconButton(
            tooltip: 'Sign out $user',
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthCubit>().signOut(),
          ),
        ],
      ),
      // A side effect happens once per state change, so it goes in a listener.
      // In a builder it would fire again on every rebuild.
      body: BlocListener<TodoBloc, TodoState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status != Status.failure) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Load failed')));
        },
        child: const TodoView(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddPage(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

// select: rebuilds only when the number it returns changes, not on every state.
class _OpenCount extends StatelessWidget {
  const _OpenCount();

  @override
  Widget build(BuildContext context) {
    final open = context.select(
      (TodoBloc bloc) => bloc.state.todos.where((t) => !t.done).length,
    );
    return Text('Todos: $open open');
  }
}

class TodoView extends StatelessWidget {
  const TodoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _LoadingBar(),
        Expanded(
          child: BlocBuilder<TodoBloc, TodoState>(
            // Skips the rebuild when only the status changed.
            buildWhen: (previous, current) => previous.todos != current.todos,
            builder: (context, state) => ListView(
              children: [
                for (final t in state.todos)
                  TodoTile(
                    t,
                    key: ValueKey(t.id),
                    onToggle: () =>
                        context.read<TodoBloc>().add(TodoToggled(t.id)),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// watch: this whole widget depends on the state, so it rebuilds on every change.
class _LoadingBar extends StatelessWidget {
  const _LoadingBar();

  @override
  Widget build(BuildContext context) {
    final status = context.watch<TodoBloc>().state.status;
    return status == Status.loading
        ? const LinearProgressIndicator()
        : const SizedBox(height: 4);
  }
}
