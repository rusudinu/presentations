// The data source: raw JSON in and out. A real one wraps dio or Firestore.
// This one keeps the todos in memory and waits like a network call would.
class TodoApi {
  final _todos = <String, Map<String, dynamic>>{
    '1': {'id': '1', 'title': 'Read the BLoC slides', 'done': true},
    '2': {'id': '2', 'title': 'Write a Cubit', 'done': false},
  };

  // Set from the demo screen to make the next getTodos call fail.
  bool failNextRequest = false;

  Future<List<Map<String, dynamic>>> getTodos() async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (failNextRequest) {
      failNextRequest = false;
      throw Exception('503 Service Unavailable');
    }
    return _todos.values.toList();
  }

  Future<void> putTodo(Map<String, dynamic> json) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _todos[json['id'] as String] = json;
  }
}
