// Null safety in Dart and Kotlin. The Dart version is find_email.dart, next to this file.
// Run: kotlinc FindEmail.kt -include-runtime -d find_email.jar && java -jar find_email.jar

val emails = mapOf(1 to "ada@example.com")

fun findEmail(id: Int): String? = emails[id]

fun send(email: String) = println("Sending to $email")

fun notify(id: Int) {
    val email = findEmail(id)
    if (email == null) return
    send(email) // smart cast to String
}

class Mailer {
    lateinit var sender: String // Dart: late final, which also works for final fields
}

fun main() {
    notify(1) // sends
    notify(2) // no email for this id, returns early

    // The operators map almost one to one.
    val email = findEmail(2)
    println(email?.length) //          Dart: email?.length
    println(email ?: "no email") //    Dart: email ?? 'no email'
    println(findEmail(1)!!.length) //  Dart: findEmail(1)!.length

    val mailer = Mailer()
    mailer.sender = "noreply@example.com"
    println(mailer.sender)
}
