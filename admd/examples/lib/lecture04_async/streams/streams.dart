// Streams: reading with await for, subscribing with listen, and cancelling.
// Run: dart run lib/lecture04_async/streams/streams.dart

import 'ticker.dart';

Future<void> main() async {
  const interval = Duration(milliseconds: 300);

  // await for reads a Stream. take(3) ends the endless ticker after three values.
  print('1. await for');
  await for (final i in ticker(interval).take(3)) {
    print('  tick $i');
  }

  // Streams have the same lazy operators as Iterable.
  print('2. where and map');
  await for (final label in ticker(
    interval,
  ).where((i) => i.isEven).map((i) => 'even $i').take(2)) {
    print('  $label');
  }

  // listen is the callback style. It returns the subscription you have to cancel.
  print('3. listen and cancel');
  final subscription = ticker(interval).listen((i) => print('  heard $i'));
  await Future.delayed(interval * 3.5);
  await subscription.cancel(); // in a widget, this line goes in dispose()
  print('  cancelled: the ticker stops, and the program can exit');
}
