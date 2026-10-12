import 'package:dio/dio.dart';

// Search as you type: every keystroke fires a request, and the previous one is
// cancelled before the next is sent.
class SearchClient {
  SearchClient(this._dio, {required this.render});

  final Dio _dio;
  final void Function(String query, List<String> results) render;
  CancelToken? _token;

  Future<void> search(String query) async {
    _token?.cancel('superseded');
    final token = _token = CancelToken();
    try {
      final res = await _dio.get<List<dynamic>>(
        '/search',
        queryParameters: {'q': query},
        cancelToken: token,
      );
      render(query, res.data!.cast<String>());
    } on DioException catch (e) {
      // A cancelled request is not an error. Anything else still is.
      if (e.type != DioExceptionType.cancel) rethrow;
    }
  }

  // Call from dispose(), so a closed screen does not render into dead state.
  void dispose() => _token?.cancel('disposed');
}
