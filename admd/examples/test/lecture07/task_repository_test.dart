// The repository against a real HTTP server on localhost: JSON becomes models,
// transient failures are retried, and what is left surfaces as ApiFailure.
import 'package:dio/dio.dart';
import 'package:flutter_examples/lecture07_networking/tasks/api/api_failure.dart';
import 'package:flutter_examples/lecture07_networking/tasks/api/dio_client.dart';
import 'package:flutter_examples/lecture07_networking/tasks/api/task_repository.dart';
import 'package:flutter_examples/lecture07_networking/tasks/fake_server.dart';
import 'package:flutter_examples/lecture07_networking/tasks/models/task.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FakeTaskServer server;
  late Dio dio;
  late TaskRepository repo;

  setUp(() async {
    server = await FakeTaskServer.start();
    dio = buildDio(baseUrl: server.baseUrl, token: () => FakeTaskServer.token);
    repo = TaskRepository(dio, retryBaseMs: 1);
  });

  tearDown(() async {
    dio.close(force: true);
    await server.stop();
  });

  Task newTask(String title) => Task(
    title: title,
    status: Status.pending,
    dueAt: DateTime.utc(2026, 11, 9),
  );

  test('fetchTasks parses the enum, the date and the nested reading', () async {
    final task = (await repo.fetchTasks()).single;

    expect(task.status, Status.pending);
    expect(task.dueAt, DateTime.utc(2026, 11, 2, 9));
    expect(task.lastReading?.deviceId, 'kitchen');
    expect(task.lastReading?.tempC, 21.0);
  });

  test('two 503 answers are retried and hidden from the caller', () async {
    server.failNext = 2;

    expect(await repo.fetchTasks(), hasLength(1));
    expect(server.received, ['GET /tasks', 'GET /tasks', 'GET /tasks']);
  });

  test('when the retries run out the caller gets an ApiFailure', () async {
    server.failNext = 5;

    await expectLater(
      repo.fetchTasks(),
      throwsA(isA<ApiFailure>().having((e) => e.statusCode, 'status', 503)),
    );
    expect(server.received, hasLength(5));
  });

  test('a retried POST with the same key adds the task once', () async {
    server.failNext = 1;

    final saved = await repo.addTask(newTask('Battery'), idempotencyKey: 'k1');
    await repo.addTask(newTask('Battery'), idempotencyKey: 'k1');

    expect(saved.id, 2);
    expect(await repo.fetchTasks(), hasLength(2));
  });

  test('a 422 is not retried', () async {
    await expectLater(
      repo.addTask(newTask(''), idempotencyKey: 'k2'),
      throwsA(isA<ApiFailure>().having((e) => e.statusCode, 'status', 422)),
    );
    expect(server.received, ['POST /tasks']);
  });
}
