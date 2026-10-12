import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/api_failure.dart';
import '../api/task_repository.dart';
import '../models/task.dart';
import '../models/task_state.dart';

// The layer between the screen and the repository. It imports no HTTP client:
// it gets models, or an ApiFailure.
class TaskCubit extends Cubit<TaskState> {
  TaskCubit(this._repository) : super(const TaskState.loading());

  final TaskRepository _repository;
  int _nextKey = 0;

  Future<void> load() async {
    emit(const TaskState.loading());
    try {
      emit(TaskState.data(await _repository.fetchTasks()));
    } on ApiFailure catch (e) {
      emit(TaskState.error(e.message));
    }
  }

  Future<void> add(Task task) async {
    final current = switch (state) {
      TaskData(:final tasks) => tasks,
      _ => const <Task>[],
    };
    emit(const TaskState.loading());
    try {
      final saved = await _repository.addTask(
        task,
        // One key per user action, so a retry of this call cannot add the task twice.
        idempotencyKey: 'add-${_nextKey++}',
      );
      emit(TaskState.data([...current, saved]));
    } on ApiFailure catch (e) {
      emit(TaskState.error(e.message));
    }
  }
}
