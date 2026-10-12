// Unit tests: plain Dart, no widgets, milliseconds to run.
import 'package:flutter_examples/lecture14_polish/forms/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('validateEmail', () {
    test('rejects an empty value', () {
      expect(validateEmail(''), 'Enter your email');
    });

    test('treats null and spaces as empty', () {
      expect(validateEmail(null), 'Enter your email');
      expect(validateEmail('   '), 'Enter your email');
    });

    test('names the missing @', () {
      expect(validateEmail('ana.example.com'), 'This address is missing an @');
    });

    test('accepts a normal address', () {
      expect(validateEmail('ana@example.com'), isNull);
    });
  });

  group('validatePassword', () {
    test('asks for at least 8 characters', () {
      expect(validatePassword('1234567'), 'Use at least 8 characters');
      expect(validatePassword('12345678'), isNull);
    });
  });
}
