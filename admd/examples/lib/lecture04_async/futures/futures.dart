// Futures: a value that is not there yet, with a type that is known now.
// Run: dart run lib/lecture04_async/futures/futures.dart

Future<String> fetchName() {
  return Future.delayed(const Duration(seconds: 1), () => 'Dinu');
}

void main() {
  // then registers a callback and returns at once.
  fetchName().then(print);
  print('This runs first.');

  // then returns a new Future, so callbacks chain.
  fetchName()
      .then((name) => name.toUpperCase())
      .then((shouted) => print('chained: $shouted'));

  // A Future that already has its value still delivers it later, never during this call.
  Future.value('already complete').then(print);
  print('This runs second.');
}
