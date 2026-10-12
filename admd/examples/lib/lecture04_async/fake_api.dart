// A stand-in for a real backend, so the lecture 4 examples run without a network.
// Every call waits 200 ms, the way an HTTP request through dio would.

const latency = Duration(milliseconds: 200);

class User {
  const User({required this.id, required this.name});

  factory User.fromJson(Map<String, dynamic> json) =>
      User(id: json['id'] as String, name: json['name'] as String);

  final String id;
  final String name;

  @override
  String toString() => 'User($id, $name)';
}

// What a failed request throws. dio throws DioException in the same place.
class ApiException implements Exception {
  const ApiException(this.statusCode, this.path);

  final int statusCode;
  final String path;

  @override
  String toString() => 'ApiException: $statusCode for $path';
}

const _users = {
  '1': {'id': '1', 'name': 'Dinu'},
  '2': {'id': '2', 'name': 'Ada'},
};

Future<Map<String, dynamic>> getJson(String path) async {
  await Future.delayed(latency);
  final id = path.split('/').last;
  final user = _users[id];
  if (user == null) throw ApiException(404, path);
  return user;
}

Future<User> loadUser(String id) async {
  final json = await getJson('/users/$id');
  return User.fromJson(json);
}

Future<List<String>> loadPosts(String id) async {
  await Future.delayed(latency);
  return ['First post by $id', 'Second post by $id'];
}
