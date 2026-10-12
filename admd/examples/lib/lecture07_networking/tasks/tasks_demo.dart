// Lecture 7 from top to bottom against a server on localhost: timeouts, failure
// paths, interceptors, cancel tokens, package:http, retries, generated JSON, the repository.
// Run: dart run lib/lecture07_networking/tasks/tasks_demo.dart

import 'dart:convert';

import 'package:dio/dio.dart';

import 'api/api_failure.dart';
import 'api/dio_client.dart';
import 'api/reading_api.dart';
import 'api/search_client.dart';
import 'api/task_repository.dart';
import 'api/with_retry.dart';
import 'fake_server.dart';
import 'models/task.dart';
import 'models/task_state.dart';

Future<void> main() async {
  final server = await FakeTaskServer.start();
  final dio = buildDio(
    baseUrl: server.baseUrl,
    token: () => FakeTaskServer.token,
    log: (line) => print('    $line'),
  );

  print('1. dio request: the interceptor adds the token and logs');
  final reading = await fetchReading(dio, 'kitchen');
  print('  ${reading.deviceId}: ${reading.tempC} °C');

  print(
    '2. Failure path: a 404 arrives as DioException and leaves as ApiFailure',
  );
  try {
    await fetchReading(dio, 'missing');
  } on ApiFailure catch (e) {
    print('  $e');
  }

  print('3. Without the interceptor there is no token: 401');
  try {
    await fetchReading(Dio(BaseOptions(baseUrl: server.baseUrl)), 'kitchen');
  } on ApiFailure catch (e) {
    print('  status ${e.statusCode}');
  }

  print('4. Timeout: the endpoint needs 2 s, the budget is 500 ms');
  try {
    await dio.get<dynamic>(
      '/slow',
      options: Options(receiveTimeout: const Duration(milliseconds: 500)),
    );
  } on DioException catch (e) {
    print('  ${e.type}');
  }

  print('5. Cancel tokens: three keystrokes, one result');
  final search = SearchClient(
    dio,
    render: (query, results) => print('  rendered "$query": $results'),
  );
  await Future.wait([
    search.search('t'),
    search.search('te'),
    search.search('temp'),
  ]);

  print('6. package:http: the status check is yours');
  final viaHttp = await fetchReadingWithHttp(
    server.baseUrl,
    'hall',
    FakeTaskServer.token,
  );
  print('  ${viaHttp.deviceId}: ${viaHttp.tempC} °C');
  try {
    await fetchReadingWithHttp(server.baseUrl, 'missing', FakeTaskServer.token);
  } on ApiFailure catch (e) {
    print('  $e');
  }

  print(
    '7. Retry with backoff and jitter: the server fails twice, then answers',
  );
  server.failNext = 2;
  final res = await withRetry(
    () => dio.get<List<dynamic>>('/tasks'),
    onRetry: (attempt, waitMs, e) => print(
      '  retry $attempt after $waitMs ms (status ${e.response?.statusCode})',
    ),
  );
  print('  ${res.data!.length} task after the retries');

  print('8. A 404 is not retried');
  server.received.clear();
  try {
    await withRetry(() => dio.get<dynamic>('/readings/missing'));
  } on DioException catch (e) {
    print(
      '  status ${e.response?.statusCode} after ${server.received.length} request',
    );
  }

  print('9. Generated JSON: enum, DateTime and a nested object');
  final task = Task.fromJson((res.data!.first as Map).cast<String, dynamic>());
  print('  ${task.title}, ${task.status}, due ${task.dueAt.toLocal()}');
  print('  last reading: ${task.lastReading?.tempC} °C');
  print('  ${jsonEncode(task.toJson())}');

  print('10. The repository: models in, models out, ApiFailure on failure');
  final repo = TaskRepository(dio);
  final added = await repo.addTask(
    Task(
      title: 'Replace the battery',
      status: Status.pending,
      dueAt: DateTime(2026, 11, 9),
    ),
    idempotencyKey: 'demo-key-1',
  );
  print('  added with id ${added.id}');
  server.failNext = 1; // the first POST fails, the retry carries the same key
  final again = await repo.addTask(
    Task(
      title: 'Replace the battery',
      status: Status.pending,
      dueAt: DateTime(2026, 11, 9),
    ),
    idempotencyKey: 'demo-key-1',
  );
  print(
    '  same key again: id ${again.id}, ${(await repo.fetchTasks()).length} tasks in total',
  );
  try {
    await repo.addTask(
      Task(title: '', status: Status.pending, dueAt: DateTime(2026, 11, 9)),
      idempotencyKey: 'demo-key-2',
    );
  } on ApiFailure catch (e) {
    print('  $e');
  }

  print('11. freezed: a sealed union with value equality');
  const TaskState state = TaskState.error('No connection');
  print('  $state');
  print('  equal by value: ${state == const TaskState.error('No connection')}');
  print(switch (state) {
    TaskLoading() => '  loading',
    TaskData(:final tasks) => '  ${tasks.length} tasks',
    TaskError(:final message) => '  error: $message',
  });

  search.dispose();
  dio.close();
  await server.stop();
}
