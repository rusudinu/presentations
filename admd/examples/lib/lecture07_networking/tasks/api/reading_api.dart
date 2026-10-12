import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import '../models/reading.dart';
import 'api_failure.dart';

// The same request with the two clients.

// dio: a status outside 2xx, a timeout and a dropped connection all arrive as DioException.
// The response body is already decoded.
Future<Reading> fetchReading(Dio dio, String id) async {
  try {
    final r = await dio.get<Json>('/readings/$id');
    return Reading.fromJson(r.data!);
  } on DioException catch (e) {
    final status = e.response?.statusCode;
    throw ApiFailure(
      status == null ? e.message ?? 'network error' : 'status $status',
      statusCode: status,
    );
  }
}

// package:http: any status is a normal response, so the status check is yours,
// and so are decoding, timeouts and headers.
Future<Reading> fetchReadingWithHttp(
  String base,
  String id,
  String token,
) async {
  final res = await http
      .get(
        Uri.parse('$base/readings/$id'),
        headers: {'Authorization': 'Bearer $token'},
      )
      .timeout(const Duration(seconds: 10));

  if (res.statusCode == 200) {
    return Reading.fromJson(jsonDecode(res.body) as Json);
  }
  throw ApiFailure('status ${res.statusCode}', statusCode: res.statusCode);
}
