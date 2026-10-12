// Which failures withRetry repeats, and how often.
import 'package:dio/dio.dart';
import 'package:flutter_examples/lecture07_networking/tasks/api/with_retry.dart';
import 'package:flutter_test/flutter_test.dart';

DioException failure(int status, {String method = 'GET', String? key}) {
  final request = RequestOptions(
    path: '/tasks',
    method: method,
    headers: {'Idempotency-Key': ?key},
  );
  return DioException(
    requestOptions: request,
    type: DioExceptionType.badResponse,
    response: Response(requestOptions: request, statusCode: status),
  );
}

void main() {
  test('503, 429 and 408 are retryable, 4xx client errors are not', () {
    expect(isRetryable(failure(503)), isTrue);
    expect(isRetryable(failure(429)), isTrue);
    expect(isRetryable(failure(408)), isTrue);
    for (final status in [400, 401, 403, 404, 422]) {
      expect(isRetryable(failure(status)), isFalse, reason: '$status');
    }
  });

  test('a POST is retryable only with an idempotency key', () {
    expect(isRetryable(failure(503, method: 'POST')), isFalse);
    expect(isRetryable(failure(503, method: 'POST', key: 'k1')), isTrue);
  });

  test('retries until the call succeeds', () async {
    var calls = 0;
    final result = await withRetry(() async {
      if (++calls < 3) throw failure(503);
      return 'ok';
    }, baseMs: 1);

    expect(result, 'ok');
    expect(calls, 3);
  });

  test('gives up after five attempts', () async {
    var calls = 0;
    await expectLater(
      withRetry<void>(() async {
        calls++;
        throw failure(503);
      }, baseMs: 1),
      throwsA(isA<DioException>()),
    );
    expect(calls, 5);
  });

  test('does not repeat a 404', () async {
    var calls = 0;
    await expectLater(
      withRetry<void>(() async {
        calls++;
        throw failure(404);
      }, baseMs: 1),
      throwsA(isA<DioException>()),
    );
    expect(calls, 1);
  });
}
