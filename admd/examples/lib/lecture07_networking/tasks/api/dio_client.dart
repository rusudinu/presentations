import 'package:dio/dio.dart';

// One Dio for the app: base URL, timeouts and interceptors are set here, once.
Dio buildDio({
  required String baseUrl,
  required String Function() token,
  void Function(String line)? log,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      // With nothing set there is no timeout: a request can hang forever.
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Accept': 'application/json'},
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      // Runs before every request: the token is added in one place.
      // The token comes from the signed-in session. An API key that has to stay
      // secret does not belong in the app at all.
      onRequest: (options, handler) {
        options.headers['Authorization'] = 'Bearer ${token()}';
        log?.call('--> ${options.method} ${options.uri.path}');
        handler.next(options);
      },
      onResponse: (response, handler) {
        log?.call(
          '<-- ${response.statusCode} ${response.requestOptions.uri.path}',
        );
        handler.next(response);
      },
      onError: (e, handler) {
        log?.call('ERROR ${e.response?.statusCode ?? e.type.name}');
        handler.next(e); // pass it on, the caller still gets the DioException
      },
    ),
  );
  return dio;
}
