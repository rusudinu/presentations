// The repository layer: feed it a fake API, assert that JSON becomes models
// and that a failure reaches the caller.
import 'package:flutter_examples/lecture06_bloc/todos/data/todo.dart';
import 'package:flutter_examples/lecture06_bloc/todos/data/todo_api.dart';
import 'package:flutter_examples/lecture06_bloc/todos/data/todo_repository.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeTodoApi implements TodoApi {
  FakeTodoApi({this.todos = const [], this.fail = false});

  final List<Map<String, dynamic>> todos;
  final bool fail;
  final saved = <Map<String, dynamic>>[];

  @override
  bool failNextRequest = false;

  @override
  Future<List<Map<String, dynamic>>> getTodos() async {
    if (fail) throw Exception('offline');
    return todos;
  }

  @override
  Future<void> putTodo(Map<String, dynamic> json) async => saved.add(json);
}

void main() {
  test('fetchTodos turns JSON into models', () async {
    final repo = TodoRepository(
      FakeTodoApi(
        todos: [
          {'id': '1', 'title': 'milk', 'done': true},
          {'id': '2', 'title': 'bread'},
        ],
      ),
    );

    expect(await repo.fetchTodos(), const [
      Todo(id: '1', title: 'milk', done: true),
      Todo(id: '2', title: 'bread'),
    ]);
  });

  test('fetchTodos lets the failure reach the caller', () {
    final repo = TodoRepository(FakeTodoApi(fail: true));

    expect(repo.fetchTodos(), throwsException);
  });

  test('save sends the model as JSON', () async {
    final api = FakeTodoApi();

    await TodoRepository(api).save(const Todo(id: '1', title: 'milk'));

    expect(api.saved, [
      {'id': '1', 'title': 'milk', 'done': false},
    ]);
  });
}
