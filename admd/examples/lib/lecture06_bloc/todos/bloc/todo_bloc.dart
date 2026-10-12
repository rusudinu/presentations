import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/todo.dart';
import '../data/todo_repository.dart';
import 'todo_event.dart';
import 'todo_state.dart';

export 'todo_event.dart';
export 'todo_state.dart';

// Events in, states out. The rules live here, and nothing in this file knows about widgets.
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc(this._repo) : super(const TodoState()) {
    on<TodosRequested>(_onRequested);
    on<TodoAdded>(_onAdded);
    on<TodoToggled>(_onToggled);
  }

  final TodoRepository _repo;

  Future<void> _onRequested(
    TodosRequested event,
    Emitter<TodoState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final todos = await _repo.fetchTodos();
      emit(state.copyWith(status: Status.ready, todos: todos));
    } catch (_) {
      emit(state.copyWith(status: Status.failure));
    }
  }

  Future<void> _onAdded(TodoAdded event, Emitter<TodoState> emit) async {
    final todo = Todo(id: '${state.todos.length + 1}', title: event.title);
    // A new list. state.todos.add(todo) would change the list inside the current
    // state, the new state would compare equal to it, and nothing would rebuild.
    emit(state.copyWith(status: Status.ready, todos: [...state.todos, todo]));
    await _repo.save(todo);
  }

  Future<void> _onToggled(TodoToggled event, Emitter<TodoState> emit) async {
    final index = state.todos.indexWhere((t) => t.id == event.id);
    if (index == -1) return;
    final toggled = state.todos[index].copyWith(done: !state.todos[index].done);
    emit(
      state.copyWith(
        status: Status.ready,
        todos: [
          for (final t in state.todos)
            if (t.id == event.id) toggled else t,
        ],
      ),
    );
    await _repo.save(toggled);
  }
}
