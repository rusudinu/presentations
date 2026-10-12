// Asynchronous code preview: a Future is a value that arrives later.
// The full model, the event loop, error handling and streams, is Lecture 4.
// Run: dart run lib/lecture02_dart/basics/async_preview.dart

Future<String> fetchName() async {
  await Future.delayed(
    const Duration(seconds: 1),
  ); // stands in for a network call
  return 'Ada';
}

Future<void> main() async {
  final pending = fetchName();
  print('right away: $pending');

  final name = await pending; // waits here without blocking the thread
  print('one second later: $name');
}
