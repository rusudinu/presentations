// Sound null safety: flow analysis promotes a nullable to non-nullable.
// Run: dart run lib/lecture02_dart/null_safety/flow_promotion.dart

String greet(String? name) {
  if (name == null) {
    return 'Hello, stranger';
  }
  // Promoted to String: no ! needed here.
  // Delete the check above and this line stops compiling.
  return 'Hello, ${name.toUpperCase()}';
}

class Profile {
  String? nickname;
}

// A local variable is promoted, a mutable field is not: another piece of code
// could set the field back to null between the check and the use.
String describe(Profile profile) {
  // if (profile.nickname != null) return profile.nickname.toUpperCase();
  // Compilation error: the field is still String? after the check.

  final nickname = profile.nickname; // copy to a local, then check the local
  if (nickname != null) {
    return nickname.toUpperCase();
  }
  return 'no nickname';
}

void main() {
  print(greet(null));
  print(greet('Ada'));

  final profile = Profile();
  print(describe(profile));
  profile.nickname = 'countess';
  print(describe(profile));
}
