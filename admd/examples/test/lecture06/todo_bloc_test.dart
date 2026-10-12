// The bloc layer: feed it a fake repository, assert the sequence of states for
// each event, including the failure path. No widgets, no emulator.
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_examples/lecture06_bloc/todos/bloc/todo_bloc.dart';
import 'package:flutter_examples/lecture06_bloc/todos/data/todo.dart';
import 'package:flutter_examples/lecture06_bloc/todos/data/todo_repository.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeTodoRepository implements TodoRepository {
  FakeTodoRepository({this.todos = const [], this.fail = false});

  final List<Todo> todos;
  final bool fail;

  @override
  Future<List<Todo>> fetchTodos() async {
    if (fail) throw Exception('offline');
    return todos;
  }

  @override
  Future<void> save(Todo todo) async {}
}

// The mistake from the slides: change the list inside the state, emit the same object.
class MutatingCubit extends Cubit<TodoState> {
  MutatingCubit() : super(TodoState(todos: []));

  void add(Todo todo) {
    state.todos.add(todo);
    emit(state);
  }
}

const milk = Todo(id: '1', title: 'milk');
const milkDone = Todo(id: '1', title: 'milk', done: true);

void main() {
  blocTest<TodoBloc, TodoState>(
    'request emits loading, then ready with the todos',
    build: () => TodoBloc(FakeTodoRepository(todos: const [milk])),
    act: (bloc) => bloc.add(const TodosRequested()),
    expect: () => const [
      TodoState(status: Status.loading),
      TodoState(status: Status.ready, todos: [milk]),
    ],
  );

  blocTest<TodoBloc, TodoState>(
    'request emits loading, then failure when the repository throws',
    build: () => TodoBloc(FakeTodoRepository(fail: true)),
    act: (bloc) => bloc.add(const TodosRequested()),
    expect: () => const [
      TodoState(status: Status.loading),
      TodoState(status: Status.failure),
    ],
  );

  blocTest<TodoBloc, TodoState>(
    'add then toggle emits two ready states',
    build: () => TodoBloc(FakeTodoRepository()),
    act: (bloc) => bloc
      ..add(const TodoAdded('milk'))
      ..add(const TodoToggled('1')),
    expect: () => const [
      TodoState(status: Status.ready, todos: [milk]),
      TodoState(status: Status.ready, todos: [milkDone]),
    ],
  );

  blocTest<MutatingCubit, TodoState>(
    'mutating the state in place emits nothing',
    build: MutatingCubit.new,
    // The package lets the very first emit of a bloc through even when the state
    // is equal, so the cubit gets one ordinary state first.
    seed: () => TodoState(todos: []),
    act: (cubit) => cubit.add(milk),
    expect: () => const <TodoState>[],
    verify: (cubit) => expect(cubit.state.todos, [milk]),
  );
}
