// late and required: a non-nullable type where the value is not available yet.
// Run: dart run lib/lecture02_dart/null_safety/late_and_required.dart

class Database {
  final String path;
  Database(this.path);
}

Database openDatabase() {
  print('  opening the database');
  return Database('app.db');
}

// late: a promise to assign before use.
class Repo {
  late final Database db;

  Repo() {
    db = openDatabase();
  }
}

// late with an initializer is lazy: it runs on the first read, and only once.
class Report {
  late final String body = _render();

  String _render() {
    print('  rendering the report');
    return 'Report body';
  }
}

// A broken promise: nothing assigns token before it is read.
class Session {
  late final String token;
}

// required: a compile-time obligation on the caller.
String card({required String title}) {
  return title;
}

void main() {
  print('Repo:');
  final repo = Repo();
  print('  db at ${repo.db.path}');

  print('Report:');
  final report = Report();
  print('  created, nothing rendered yet');
  print('  ${report.body}');
  print('  ${report.body} (second read, not rendered again)');

  print('Session:');
  try {
    print(Session().token);
  } catch (e) {
    print('  $e');
  }

  print('card:');
  print('  ${card(title: 'Null safety')}');
  // card(); // Compilation error: the named parameter title is required.
}
