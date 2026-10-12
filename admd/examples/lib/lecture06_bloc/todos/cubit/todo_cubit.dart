import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/todo_state.dart';
import '../data/todo.dart';
import '../data/todo_repository.dart';

// The same feature as TodoBloc, as a Cubit: the inputs are method calls.
// Start here, and promote it to a Bloc when the inputs need logging or debouncing.
class TodoCubit extends Cubit<TodoState> {
  TodoCubit(this._repo) : super(const TodoState());

  final TodoRepository _repo;

  Future<void> load() async {
    emit(state.copyWith(status: Status.loading));
    try {
      final todos = await _repo.fetchTodos();
      emit(state.copyWith(status: Status.ready, todos: todos));
    } catch (_) {
      emit(state.copyWith(status: Status.failure));
    }
  }

  Future<void> add(String title) async {
    final todo = Todo(id: '${state.todos.length + 1}', title: title);
    emit(state.copyWith(status: Status.ready, todos: [...state.todos, todo]));
    await _repo.save(todo);
  }
}
