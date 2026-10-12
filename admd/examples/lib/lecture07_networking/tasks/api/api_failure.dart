// The one error type the layers above the repository see. They never see Dio.
class ApiFailure implements Exception {
  const ApiFailure(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => statusCode == null
      ? 'ApiFailure: $message'
      : 'ApiFailure: $message (status $statusCode)';
}
