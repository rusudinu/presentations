import 'dart:math';

import 'package:dio/dio.dart';

const _idempotentMethods = {'GET', 'HEAD', 'PUT', 'DELETE'};

// Retry only calls where a repeat is harmless, and only failures that can go away.
bool isRetryable(DioException e) {
  // A POST without an idempotency key may already have been applied.
  final request = e.requestOptions;
  final repeatable =
      _idempotentMethods.contains(request.method.toUpperCase()) ||
      request.headers.containsKey('Idempotency-Key');
  if (!repeatable) return false;

  return switch (e.type) {
    // No response at all: the connection failed.
    DioExceptionType.connectionError ||
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout => true,
    // 408, 429 and 5xx are transient. 400, 401, 403, 404 and 422 are not.
    DioExceptionType.badResponse => switch (e.response?.statusCode) {
      408 || 429 => true,
      final int code => code >= 500,
      null => false,
    },
    _ => false,
  };
}

// Exponential backoff with full jitter: before retry a, wait a random time
// below baseMs * 2^a. Five attempts in total.
Future<T> withRetry<T>(
  Future<T> Function() call, {
  int baseMs = 200,
  void Function(int attempt, int waitMs, DioException e)? onRetry,
}) async {
  for (var a = 0; ; a++) {
    try {
      return await call();
    } on DioException catch (e) {
      if (!isRetryable(e) || a == 4) rethrow;
      final wait = Random().nextInt(baseMs << a);
      onRetry?.call(a + 1, wait, e);
      await Future.delayed(Duration(milliseconds: wait));
    }
  }
}
