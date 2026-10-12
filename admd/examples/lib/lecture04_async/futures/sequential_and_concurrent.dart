// Sequential and concurrent awaits: two 200 ms calls cost 400 ms or 200 ms.
// Run: dart run lib/lecture04_async/futures/sequential_and_concurrent.dart

import '../fake_api.dart';

Future<void> main() async {
  const id = '1';
  final watch = Stopwatch()..start();

  // Sequential: one after another.
  final user = await loadUser(id);
  final posts = await loadPosts(id);
  print(
    'sequential: ${watch.elapsedMilliseconds} ms, $user, ${posts.length} posts',
  );

  // Concurrent: both start now.
  watch.reset();
  final results = await Future.wait([loadUser(id), loadPosts(id)]);
  print('Future.wait: ${watch.elapsedMilliseconds} ms, $results');

  // The same on a record: each result keeps its own type, so no casts.
  watch.reset();
  final (sameUser, samePosts) = await (loadUser(id), loadPosts(id)).wait;
  print(
    'record.wait: ${watch.elapsedMilliseconds} ms, ${sameUser.name}, ${samePosts.first}',
  );

  // A call starts when the function is called, not when it is awaited.
  watch.reset();
  final userFuture = loadUser(id);
  final postsFuture = loadPosts(id);
  await userFuture;
  await postsFuture;
  print('started first, awaited later: ${watch.elapsedMilliseconds} ms');
}
