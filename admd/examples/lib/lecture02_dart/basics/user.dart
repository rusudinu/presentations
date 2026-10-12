// Kotlin and Dart compared: a small model class. The Kotlin version is User.kt, next to this file.
// Run: dart run lib/lecture02_dart/basics/user.dart

class User {
  final String name;
  final int age;
  const User(this.name, this.age);
}

// What Kotlin's data class generates, written by hand.
// Equatable (Lecture 5) and freezed (Lecture 7) generate it instead.
class DataUser {
  final String name;
  final int age;
  const DataUser(this.name, this.age);

  DataUser copyWith({String? name, int? age}) =>
      DataUser(name ?? this.name, age ?? this.age);

  @override
  bool operator ==(Object other) =>
      other is DataUser && other.name == name && other.age == age;

  @override
  int get hashCode => Object.hash(name, age);

  @override
  String toString() => 'DataUser(name=$name, age=$age)';
}

void main() {
  // ignore: prefer_const_constructors -- two separate objects are the point here
  final u = User('Ada', 36);
  // ignore: prefer_const_constructors -- two separate objects are the point here
  final same = User('Ada', 36);
  print(u); // Instance of 'User'
  print('u == same: ${u == same}'); // false: identity

  // const objects with the same fields are one object, so they compare equal.
  print('const: ${identical(const User('Ada', 36), const User('Ada', 36))}');

  final d = DataUser('Ada', 36);
  print(d);
  print('d == DataUser: ${d == DataUser('Ada', 36)}');
  print(d.copyWith(age: 37));
}
