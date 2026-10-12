import 'package:equatable/equatable.dart';

import '../data/todo.dart';

enum Status { initial, loading, ready, failure }

// One state class with a status: the list stays available while a reload runs.
class TodoState extends Equatable {
  const TodoState({this.status = Status.initial, this.todos = const []});

  final Status status;
  final List<Todo> todos;

  TodoState copyWith({Status? status, List<Todo>? todos}) =>
      TodoState(status: status ?? this.status, todos: todos ?? this.todos);

  // Add a field, add it here.
  @override
  List<Object?> get props => [status, todos];
}
