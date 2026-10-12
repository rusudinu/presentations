// Errors in awaited calls: every await is a place the code can fail.
// Run: dart run lib/lecture04_async/futures/await_errors.dart

import 'dart:async';

import '../fake_api.dart';

Future<void> refresh(String id) async {
  try {
    final user = await loadUser(id);
    print('  loaded $user');
  } on ApiException catch (e) {
    // The failure you expect, by type.
    print('  network error: $e');
  } catch (e, stack) {
    // Anything else. An app reports this to Crashlytics.
    print('  unexpected: $e\n$stack');
  } finally {
    // Runs on success and on failure. This is where the loading flag goes back to false.
    print('  finally: loading = false');
  }
}

Future<void> main() async {
  print('1. A failure does not throw at the call site');
  final future = loadUser('missing');
  print('  the call returned $future');
  try {
    await future; // await rethrows the error here
  } on ApiException catch (e) {
    print('  caught at the await: $e');
  }

  print('2. One specific catch, one general catch, finally');
  await refresh('1');
  await refresh('missing');

  print('3. Future.wait fails as soon as one Future fails');
  try {
    await Future.wait([loadUser('1'), loadUser('missing')]);
  } on ApiException catch (e) {
    print('  $e');
  }

  print('4. Without an await, try does not see the error');
  // runZonedGuarded stands in for the unhandled error handler of an app.
  runZonedGuarded(() {
    try {
      loadUser(
        'missing',
      ); // not awaited: the Future fails after this block is done
    } catch (e) {
      print('  never printed');
    }
  }, (error, stack) => print('  unhandled async error: $error'));
  await Future.delayed(latency * 2);
}
