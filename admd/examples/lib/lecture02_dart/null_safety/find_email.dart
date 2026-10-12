// Null safety in Dart and Kotlin. The Kotlin version is FindEmail.kt, next to this file.
// Run: dart run lib/lecture02_dart/null_safety/find_email.dart

const emails = {1: 'ada@example.com'};

String? findEmail(int id) => emails[id];

void send(String email) => print('Sending to $email');

void notify(int id) {
  final email = findEmail(id);
  if (email == null) return;
  send(email); // promoted to String
}

class Mailer {
  late final String sender; // Kotlin: lateinit var, var only
}

void main() {
  notify(1); // sends
  notify(2); // no email for this id, returns early

  // The operators map almost one to one.
  final email = findEmail(2);
  print(email?.length); //          Kotlin: email?.length
  print(email ?? 'no email'); //    Kotlin: email ?: "no email"
  print(findEmail(1)!.length); //   Kotlin: findEmail(1)!!.length

  final mailer = Mailer();
  mailer.sender = 'noreply@example.com';
  print(mailer.sender);
}
