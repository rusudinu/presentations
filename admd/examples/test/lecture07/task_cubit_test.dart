// The Cubit from "Example: adding a task", tested with a fake repository.
// No HTTP client appears here, because none appears in the Cubit.
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_examples/lecture07_networking/tasks/api/api_failure.dart';
import 'package:flutter_examples/lecture07_networking/tasks/api/task_repository.dart';
import 'package:flutter_examples/lecture07_networking/tasks/cubit/task_cubit.dart';
import 'package:flutter_examples/lecture07_networking/tasks/models/task.dart';
import 'package:flutter_examples/lecture07_networking/tasks/models/task_state.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeTaskRepository implements TaskRepository {
  FakeTaskRepository({this.tasks = const [], this.failure});

  final List<Task> tasks;
  final ApiFailure? failure;

  @override
  int get retryBaseMs => 0;

  @override
  Future<List<Task>> fetchTasks() async {
    if (failure != null) throw failure!;
    return tasks;
  }

  @override
  Future<Task> addTask(Task task, {required String idempotencyKey}) async {
    if (failure != null) throw failure!;
    return task;
  }
}

void main() {
  final task = Task(
    id: 1,
    title: 'Calibrate',
    status: Status.pending,
    dueAt: DateTime(2026, 11, 2),
  );

  blocTest<TaskCubit, TaskState>(
    'load emits loading, then the tasks',
    build: () => TaskCubit(FakeTaskRepository(tasks: [task])),
    act: (cubit) => cubit.load(),
    expect: () => [
      const TaskState.loading(),
      TaskState.data([task]),
    ],
  );

  blocTest<TaskCubit, TaskState>(
    'a failure becomes an error state with the message',
    build: () => TaskCubit(
      FakeTaskRepository(failure: const ApiFailure('No connection')),
    ),
    act: (cubit) => cubit.load(),
    expect: () => const [TaskState.loading(), TaskState.error('No connection')],
  );

  blocTest<TaskCubit, TaskState>(
    'add emits loading, then the list with the saved task',
    build: () => TaskCubit(FakeTaskRepository()),
    seed: () => const TaskState.data([]),
    act: (cubit) => cubit.add(task),
    expect: () => [
      const TaskState.loading(),
      TaskState.data([task]),
    ],
  );
}
