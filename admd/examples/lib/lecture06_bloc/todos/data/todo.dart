import 'package:equatable/equatable.dart';

// The model. Immutable and compared by value, so a state that holds a list of
// todos can tell whether anything changed.
class Todo extends Equatable {
  const Todo({required this.id, required this.title, this.done = false});

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
    id: json['id'] as String,
    title: json['title'] as String,
    done: json['done'] as bool? ?? false,
  );

  final String id;
  final String title;
  final bool done;

  Todo copyWith({String? title, bool? done}) =>
      Todo(id: id, title: title ?? this.title, done: done ?? this.done);

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'done': done};

  @override
  List<Object?> get props => [id, title, done];
}
