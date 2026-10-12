// Variables: var, final, const and dynamic.
// Run: dart run lib/lecture02_dart/basics/variables.dart

void main() {
  // var infers its type from the value. count is an int from here on.
  var count = 0;
  count = count + 1;
  // count = 'one'; // Compilation error: a String is not an int.

  String title = 'Lecture 2';

  // final: assigned once, at run time.
  final now = DateTime.now();
  // now = DateTime.now(); // Compilation error: a final variable is set once.

  // const: computed by the compiler, baked into the binary.
  const frameBudgetMs = 1000 / 120;
  // const later = DateTime.now(); // Compilation error: not a compile-time constant.

  print('$title: $frameBudgetMs ms/frame');
  print('count is $count, started at $now');

  // final protects the binding, not the object it points to.
  final topics = ['Dart'];
  topics.add('Kotlin');
  print(topics);

  // const makes the object itself immutable.
  const frozen = ['Dart'];
  try {
    frozen.add('Kotlin');
  } catch (e) {
    print('adding to a const list threw: $e');
  }

  // dynamic opts out of checking: the mistake compiles and fails at run time.
  dynamic anything = 'text';
  print(anything.length);
  try {
    anything.push('more');
  } catch (e) {
    print('dynamic call threw: ${e.runtimeType}');
  }
}
