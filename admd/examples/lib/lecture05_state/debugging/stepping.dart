// A console program to practice breakpoints on. Start it with the debugger attached:
// "Debug" above main in VS Code or Android Studio. Plain dart run has no debugger.
// Run: dart run lib/lecture05_state/debugging/stepping.dart

class Todo {
  Todo(this.id, this.title);

  final int id;
  final String title;
  bool done = false;
}

List<Todo> loadTodos() => [for (var i = 0; i < 100; i++) Todo(i, 'Todo $i')];

// Set a breakpoint on the line inside the loop, then make it conditional:
// right-click it and enter todo.id == 42. It stops once, not 100 times.
int countDone(List<Todo> todos) {
  var done = 0;
  for (final todo in todos) {
    if (todo.done) done++;
  }
  return done;
}

// Step into this call from main, then step out to return to the caller.
void markEveryThird(List<Todo> todos) {
  for (final todo in todos) {
    todo.done = todo.id % 3 == 0;
  }
}

void main() {
  final todos =
      loadTodos(); // step over: runs the call without descending into it
  markEveryThird(todos); // step into
  final done = countDone(todos);
  // While paused here, hover todos, edit done in the Variables pane,
  // and evaluate todos.where((t) => t.done).length in the debug console.
  assert(done >= 0, 'done is negative');
  print('$done of ${todos.length} done');
}
