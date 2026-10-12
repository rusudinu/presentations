// async and await: the same callbacks as then, written top to bottom.
// Run: dart run lib/lecture04_async/futures/async_await.dart

import '../fake_api.dart';

// The slide's loadUser, with the fake API in place of dio.
Future<User> fetchUser(String id) async {
  print('  fetchUser: before the await');
  final json = await getJson('/users/$id'); // suspension point
  print('  fetchUser: resumed with the response');
  return User.fromJson(json);
}

Future<void> refresh(String id) async {
  final user = await fetchUser(id);
  print('  refresh: got $user');
}

// What the compiler turns refresh into.
Future<void> refreshWithThen(String id) {
  return fetchUser(id).then((user) {
    print('  refreshWithThen: got $user');
  });
}

Future<void> main() async {
  print(
    '1. Calling without await: the function runs until its first await, then returns',
  );
  final pending = refresh('1');
  print('  main: refresh returned $pending');
  await pending;

  print('2. The same with then');
  await refreshWithThen('2');
}
