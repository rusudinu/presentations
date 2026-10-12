import 'dart:async';
import 'dart:convert';
import 'dart:io';

// A real HTTP server on localhost, so the lecture 7 task examples run without the
// internet and can fail on demand. It needs dart:io, so it does not run on the web.
class FakeTaskServer {
  FakeTaskServer._(this._server);

  static const token = 'demo-token';

  final HttpServer _server;
  final _tasks = <Map<String, dynamic>>[
    {
      'id': 1,
      'title': 'Calibrate the kitchen sensor',
      'status': 'pending',
      'due_at': '2026-11-02T09:00:00.000Z',
      'last_reading': {'device_id': 'kitchen', 'temp_c': 21},
    },
  ];
  final _appliedKeys = <String, Map<String, dynamic>>{};

  // The next n requests are answered with 503.
  int failNext = 0;

  // Requests the server received, in order: "GET /tasks".
  final received = <String>[];

  String get baseUrl => 'http://${_server.address.host}:${_server.port}';

  static Future<FakeTaskServer> start() async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final fake = FakeTaskServer._(server);
    server.listen(fake._handle);
    return fake;
  }

  Future<void> stop() => _server.close(force: true);

  Future<void> _handle(HttpRequest request) async {
    final path = request.uri.path;
    received.add('${request.method} $path');
    try {
      if (request.headers.value('authorization') != 'Bearer $token') {
        return await _send(request, 401, {'error': 'missing or wrong token'});
      }
      if (failNext > 0) {
        failNext--;
        return await _send(request, 503, {'error': 'try again later'});
      }

      if (request.method == 'GET' && path == '/tasks') {
        await Future.delayed(const Duration(milliseconds: 150));
        return await _send(request, 200, _tasks);
      }
      if (request.method == 'POST' && path == '/tasks') {
        return await _addTask(request);
      }
      if (request.method == 'GET' && path.startsWith('/readings/')) {
        final id = path.split('/').last;
        if (id == 'missing') return await _send(request, 404, {'error': id});
        return await _send(request, 200, {'device_id': id, 'temp_c': 21.5});
      }
      if (request.method == 'GET' && path == '/search') {
        final q = request.uri.queryParameters['q'] ?? '';
        await Future.delayed(const Duration(milliseconds: 300));
        return await _send(request, 200, ['$q sensor', '$q task']);
      }
      if (request.method == 'GET' && path == '/slow') {
        await Future.delayed(const Duration(seconds: 2));
        return await _send(request, 200, {'ok': true});
      }
      await _send(request, 404, {'error': 'no route for $path'});
    } catch (_) {
      // The client went away, for example after a cancel or a timeout.
    }
  }

  Future<void> _addTask(HttpRequest request) async {
    final body =
        jsonDecode(await utf8.decoder.bind(request).join())
            as Map<String, dynamic>;
    if ((body['title'] as String? ?? '').trim().isEmpty) {
      return _send(request, 422, {'error': 'title is required'});
    }
    // The same Idempotency-Key gets the first answer again, and adds nothing.
    final key = request.headers.value('idempotency-key');
    final applied = key == null ? null : _appliedKeys[key];
    if (applied != null) return _send(request, 201, applied);

    final task = {...body, 'id': _tasks.length + 1};
    _tasks.add(task);
    if (key != null) _appliedKeys[key] = task;
    return _send(request, 201, task);
  }

  Future<void> _send(HttpRequest request, int status, Object body) {
    request.response
      ..statusCode = status
      ..headers.contentType = ContentType.json
      ..write(jsonEncode(body));
    return request.response.close();
  }
}
