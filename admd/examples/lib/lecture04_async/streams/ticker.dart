// A Stream is many values, over time. This one counts up forever.
Stream<int> ticker([Duration interval = const Duration(seconds: 1)]) async* {
  for (var i = 0; ; i++) {
    await Future.delayed(interval);
    yield i;
  }
}
