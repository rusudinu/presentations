// The null safety operators: ?  ?.  ??  ??=  !
// Run: dart run lib/lecture02_dart/null_safety/operators.dart

// A map lookup returns null when the key is missing, so the return type says so.
String? findNickname(Map<String, String> profile) => profile['nickname'];

// ?. calls only if non-null. ?? supplies a fallback.
String displayName(String name, String? nickname) {
  return nickname?.trim() ?? name;
}

// ??= assigns only when the variable is still null.
String orAnonymous(String? nickname) {
  nickname ??= 'anon';
  return nickname; // promoted to String by the assignment above
}

// ! asserts non-null. The compiler believes it, the run time checks it.
int nicknameLength(String? nickname) => nickname!.length;

void main() {
  // Non-nullable by default.
  String name = 'Ada';
  // name = null; // Compilation error: null is not a String.

  // Add ? and null becomes allowed. A nullable variable starts as null.
  String? nickname;
  print('nickname starts as $nickname');

  print('shown: ${displayName(name, nickname)}'); // falls back to name
  print('shown: ${displayName(name, '  Countess  ')}'); // trims the nickname

  nickname = findNickname({'name': 'Ada'});
  print('missing key: $nickname');
  print('length or zero: ${nickname?.length ?? 0}');

  print('orAnonymous(null): ${orAnonymous(null)}');
  print("orAnonymous('ada'): ${orAnonymous('ada')}");

  print("nicknameLength('ada'): ${nicknameLength('ada')}");
  try {
    nicknameLength(null);
  } catch (e) {
    // The failure moved from build time to run time.
    print('nicknameLength(null) threw: $e');
  }
}
