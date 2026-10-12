// Classes and constructors: final fields and this.x parameters.
// Run: dart run lib/lecture02_dart/basics/classes.dart

class Lecture {
  final int number;
  final String title;
  final String? room;

  // this.x assigns the field directly. [this.room] is optional and stays null if omitted.
  Lecture(this.number, this.title, [this.room]);
}

// The same model with named parameters, the shape Flutter widgets use.
class Lab {
  final int number;
  final String title;
  final String? room;

  Lab({required this.number, required this.title, this.room});
}

void main() {
  final l = Lecture(2, 'Languages');
  print('Lecture ${l.number}: ${l.title}, room ${l.room ?? 'not set'}');

  final withRoom = Lecture(3, 'Widgets', 'EC105');
  print('Lecture ${withRoom.number}: ${withRoom.title}, room ${withRoom.room}');

  // l.title = 'Dart'; // Compilation error: a final field is set once.

  final lab = Lab(title: 'Toolchain', number: 2);
  print('Lab ${lab.number}: ${lab.title}, room ${lab.room ?? 'not set'}');
}
