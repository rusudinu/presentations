// Records: typed, immutable tuples.
// Run: dart run lib/lecture02_dart/basics/records.dart

// A record: an anonymous tuple type.
(String, int) parseLine(String line) {
  final parts = line.split(',');
  return (parts[0], int.parse(parts[1]));
}

// Named fields read like a tiny class.
({String title, int week}) nextLecture() => (title: 'Widgets', week: 3);

void main() {
  // Destructuring: one statement declares both variables.
  final (name, score) = parseLine('Ada,97');
  print('$name scored $score');

  // Without destructuring, positional fields are $1, $2.
  final result = parseLine('Grace,91');
  print('${result.$1} scored ${result.$2}');
  // result.$2 = 100; // Compilation error: a record is immutable.

  final next = nextLecture();
  print('Week ${next.week}: ${next.title}');
  final (:title, :week) = nextLecture();
  print('$title in week $week');

  // Two records are equal if their fields are equal.
  print(parseLine('Ada,97') == ('Ada', 97));
  print((title: 'Widgets', week: 3) == (week: 3, title: 'Widgets'));
}
