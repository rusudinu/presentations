import 'dart:convert';

import 'package:flutter/foundation.dart';

class Photo {
  const Photo({required this.id, required this.title});

  factory Photo.fromJson(Map<String, dynamic> json) =>
      Photo(id: json['id'] as int, title: json['title'] as String);

  final int id;
  final String title;
}

// Must be a top-level or static function.
List<Photo> parsePhotos(String body) {
  final list = jsonDecode(body) as List;
  return [
    for (final json in list) Photo.fromJson(json as Map<String, dynamic>),
  ];
}

// Stands in for http.get: waits, then returns a large JSON body.
Future<String> _getPhotosBody(int count) async {
  await Future.delayed(const Duration(milliseconds: 200));
  return jsonEncode([
    for (var i = 0; i < count; i++) {'id': i, 'title': 'Photo $i'},
  ]);
}

Future<List<Photo>> fetchPhotos({int count = 200000}) async {
  final body = await _getPhotosBody(count); // I/O: await
  // CPU: another isolate. The String goes in and the List<Photo> comes back by message.
  return compute(parsePhotos, body);
}
