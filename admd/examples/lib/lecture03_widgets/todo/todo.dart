// Step 1: start from the data. One plain Dart class, no framework types in it.
class Todo {
  Todo(this.id, this.title);

  final int id;
  final String title;
  // Mutable today. Lecture 6 replaces this with an immutable model and copyWith.
  bool done = false;
}
