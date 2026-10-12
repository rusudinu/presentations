// Getters, named constructors, and the default equality.
// Run: dart run lib/lecture02_dart/basics/getters_and_equality.dart

class Lecture {
  final int number;
  final String title;

  Lecture(this.number, this.title);

  // Another named constructor.
  Lecture.lab(this.number) : title = 'Lab';

  // A getter: computed, no parens.
  String get label => 'L$number';
}

void main() {
  final l1 = Lecture(2, 'Languages');
  final l2 = Lecture(2, 'Languages');
  final lab = Lecture.lab(2);

  print(l1.label);
  print('${lab.label}: ${lab.title}');

  // Every class gets a default toString, == and hashCode.
  print(l1); // Instance of 'Lecture'

  // Equality is identity by default: same fields, two objects, not equal.
  print('l1 == l2: ${l1 == l2}');
  print('l1 == l1: ${l1 == l1}');
  print('hash codes: ${l1.hashCode} and ${l2.hashCode}');

  // So a Set keeps both. Lecture 5 fixes this with Equatable.
  print('set size: ${{l1, l2}.length}');
}
