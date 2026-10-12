import 'package:equatable/equatable.dart';

// Every input to the bloc is a value. sealed means the list of events is closed.
sealed class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object?> get props => const [];
}

final class TodosRequested extends TodoEvent {
  const TodosRequested();
}

final class TodoAdded extends TodoEvent {
  const TodoAdded(this.title);

  final String title;

  @override
  List<Object?> get props => [title];
}

final class TodoToggled extends TodoEvent {
  const TodoToggled(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}
