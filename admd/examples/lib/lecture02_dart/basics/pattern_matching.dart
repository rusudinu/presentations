// Pattern matching: switch expressions.
// Run: dart run lib/lecture02_dart/basics/pattern_matching.dart

// Each arm is a pattern, an optional when guard, and an expression.
String describe(Object v) {
  return switch (v) {
    int n when n < 0 => 'negative',
    int() => 'a whole number',
    String s => 'text: $s',
    _ => 'something else',
  };
}

// A record destructured in the case: the arm matches the shape and binds the fields.
String grade((String, int) result) {
  return switch (result) {
    (final name, >= 90) => '$name: excellent',
    (final name, final score) when score >= 50 => '$name: passed with $score',
    (final name, _) => '$name: failed',
  };
}

enum BuildMode { debug, profile, release }

// No wildcard here. Remove one arm and the compiler reports the switch as not exhaustive.
String compiler(BuildMode mode) {
  return switch (mode) {
    BuildMode.debug => 'JIT',
    BuildMode.profile || BuildMode.release => 'AOT',
  };
}

void main() {
  for (final v in [-5, 42, 'hello', 3.14]) {
    print('$v is ${describe(v)}');
  }

  print(grade(('Ada', 97)));
  print(grade(('Linus', 60)));
  print(grade(('Bob', 12)));

  for (final mode in BuildMode.values) {
    print('${mode.name}: ${compiler(mode)}');
  }
}
