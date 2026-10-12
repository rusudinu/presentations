// Mocking with mocktail: the repository is replaced by a mock that answers what the
// test tells it to, and records how it was called. The classes are the lecture 6 todos.
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_examples/lecture06_bloc/todos/bloc/todo_bloc.dart';
import 'package:flutter_examples/lecture06_bloc/todos/cubit/todo_cubit.dart';
import 'package:flutter_examples/lecture06_bloc/todos/data/todo.dart';
import 'package:flutter_examples/lecture06_bloc/todos/data/todo_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  const todo = Todo(id: '1', title: 'Buy milk');
  late MockTodoRepository repo;

  setUp(() {
    repo = MockTodoRepository();
    when(() => repo.fetchTodos()).thenAnswer((_) async => [todo]);
  });

  test('the cubit asks the repository once', () async {
    await TodoCubit(repo).load();

    verify(() => repo.fetchTodos()).called(1);
  });

  test('a repository that throws leads to the failure status', () async {
    when(() => repo.fetchTodos()).thenThrow(Exception('offline'));
    final cubit = TodoCubit(repo);

    await cubit.load();

    expect(cubit.state.status, Status.failure);
  });

  // The same mock in a bloc test.
  blocTest<TodoBloc, TodoState>(
    'emits loading then ready when TodosRequested is added',
    build: () => TodoBloc(repo),
    act: (bloc) => bloc.add(const TodosRequested()),
    expect: () => const [
      TodoState(status: Status.loading),
      TodoState(status: Status.ready, todos: [todo]),
    ],
  );
}
