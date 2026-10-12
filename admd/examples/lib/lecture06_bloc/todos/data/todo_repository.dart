import 'todo.dart';
import 'todo_api.dart';

// One method per use case. Takes raw JSON from the data source and returns models.
// The bloc knows this class, not the network.
class TodoRepository {
  TodoRepository(this._api);

  final TodoApi _api;

  Future<List<Todo>> fetchTodos() async {
    final json = await _api.getTodos();
    return json.map(Todo.fromJson).toList();
  }

  Future<void> save(Todo todo) => _api.putTodo(todo.toJson());
}
