// "Example: adding a task": screen, Cubit, repository and dio, against a server on localhost.
// Run: flutter run -t lib/lecture07_networking/tasks/main.dart
// The server uses dart:io, so run it on a phone, an emulator or the desktop, not on the web.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'api/dio_client.dart';
import 'api/task_repository.dart';
import 'cubit/task_cubit.dart';
import 'fake_server.dart';
import 'models/task.dart';
import 'models/task_state.dart';

Future<void> main() async {
  final server = await FakeTaskServer.start();
  final dio = buildDio(
    baseUrl: server.baseUrl,
    token: () => FakeTaskServer.token,
    log: debugPrint,
  );
  runApp(TasksApp(server: server, repository: TaskRepository(dio)));
}

class TasksApp extends StatelessWidget {
  const TasksApp({super.key, required this.server, required this.repository});

  final FakeTaskServer server;
  final TaskRepository repository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: repository,
      child: BlocProvider(
        create: (context) => TaskCubit(repository)..load(),
        child: MaterialApp(
          title: 'Tasks',
          theme: ThemeData(colorSchemeSeed: Colors.indigo),
          home: TaskPage(server: server),
        ),
      ),
    );
  }
}

class TaskPage extends StatelessWidget {
  const TaskPage({super.key, required this.server});

  // Only here so the buttons can make the server fail.
  final FakeTaskServer server;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            tooltip: 'Fail twice, then reload: the retries hide it',
            icon: const Icon(Icons.replay),
            onPressed: () {
              server.failNext = 2;
              context.read<TaskCubit>().load();
            },
          ),
          IconButton(
            tooltip: 'Fail five times, then reload: the retries run out',
            icon: const Icon(Icons.cloud_off),
            onPressed: () {
              server.failNext = 5;
              context.read<TaskCubit>().load();
            },
          ),
        ],
      ),
      body: BlocBuilder<TaskCubit, TaskState>(
        // The generated union is sealed: all three cases, or it does not compile.
        builder: (context, state) => switch (state) {
          TaskLoading() => const Center(child: CircularProgressIndicator()),
          TaskData(:final tasks) => ListView(
            children: [
              for (final task in tasks)
                ListTile(
                  title: Text(task.title),
                  subtitle: Text(
                    '${task.status.name}, due ${task.dueAt.toLocal()}',
                  ),
                ),
            ],
          ),
          TaskError(:final message) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(message),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => context.read<TaskCubit>().load(),
                  child: const Text('Try again'),
                ),
              ],
            ),
          ),
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Step 1: the UI calls the Cubit, and knows nothing below it.
        onPressed: () => context.read<TaskCubit>().add(
          Task(
            title: 'Task added at ${TimeOfDay.now().format(context)}',
            status: Status.pending,
            dueAt: DateTime.now().add(const Duration(days: 7)),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
