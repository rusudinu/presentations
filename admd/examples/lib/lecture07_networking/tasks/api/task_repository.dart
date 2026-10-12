import 'package:dio/dio.dart';

import '../models/task.dart';
import 'api_failure.dart';
import 'with_retry.dart';

// Status codes, retry with jitter and generated JSON all sit inside this class.
// Every layer above it gets models or an ApiFailure.
class TaskRepository {
  TaskRepository(this._dio, {this.retryBaseMs = 200});

  final Dio _dio;
  final int retryBaseMs;

  Future<List<Task>> fetchTasks() async {
    try {
      final res = await withRetry(
        () => _dio.get<List<dynamic>>('/tasks'),
        baseMs: retryBaseMs,
      );
      return [
        for (final j in res.data!) Task.fromJson(j as Map<String, dynamic>),
      ];
    } on DioException catch (e) {
      throw _failure(e);
    }
  }

  // A POST is retried only because it carries an idempotency key: the server
  // applies the same key once, however many times it arrives.
  Future<Task> addTask(Task task, {required String idempotencyKey}) async {
    try {
      final res = await withRetry(
        () => _dio.post<Map<String, dynamic>>(
          '/tasks',
          data: task.toJson(),
          options: Options(headers: {'Idempotency-Key': idempotencyKey}),
        ),
        baseMs: retryBaseMs,
      );
      return Task.fromJson(res.data!);
    } on DioException catch (e) {
      throw _failure(e);
    }
  }

  ApiFailure _failure(DioException e) {
    final status = e.response?.statusCode;
    return ApiFailure(switch (status) {
      401 || 403 => 'Not signed in',
      422 => 'The task was rejected',
      null => 'No connection',
      _ => 'The server failed',
    }, statusCode: status);
  }
}
