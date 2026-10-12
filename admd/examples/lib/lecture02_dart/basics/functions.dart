// Functions: positional, optional positional and named parameters, functions as values.
// Run: dart run lib/lecture02_dart/basics/functions.dart

// Positional. => is a one-expression body.
int add(int a, int b) => a + b;

// Optional positional, with a default.
String tag(String n, [String s = '']) {
  return '$n$s';
}

// Named parameters: the Flutter style.
String card({required String title, String? subtitle}) =>
    subtitle == null ? title : '$title ($subtitle)';

// Functions are first-class values. This one takes a function as a parameter,
// which is what a callback like onPressed is.
void button({required String label, required void Function() onPressed}) {
  print('[$label] pressed');
  onPressed();
}

// And this one returns a function.
int Function(int) multiplyBy(int factor) =>
    (value) => value * factor;

void main() {
  print(add(2, 3));

  print(tag('lab'));
  print(tag('lab', '-2'));

  // Named arguments can come in any order and say what each value is.
  print(card(title: 'Null safety'));
  print(card(subtitle: 'Part 1', title: 'Null safety'));

  button(label: 'Save', onPressed: () => print('saving'));

  // Stored in a variable, then called.
  final triple = multiplyBy(3);
  print(triple(14));

  // Passed by name: add has the shape reduce expects.
  print([1, 2, 3, 4].reduce(add));
}
