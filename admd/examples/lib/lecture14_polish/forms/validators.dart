// Validators are plain functions: null means valid, a String is the message.
// Being plain functions is what makes them unit testable: test/lecture14/validators_test.dart.

String? validateEmail(String? v) {
  final s = v?.trim() ?? '';
  if (s.isEmpty) return 'Enter your email';
  if (!s.contains('@')) {
    return 'This address is missing an @';
  }
  return null; // null means valid
}

String? validatePassword(String? v) {
  final s = v ?? '';
  if (s.isEmpty) return 'Enter your password';
  if (s.length < 8) return 'Use at least 8 characters';
  return null;
}
