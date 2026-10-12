// Kotlin and Dart compared: a small model class. The Dart version is user.dart, next to this file.
// Run: kotlinc User.kt -include-runtime -d user.jar && java -jar user.jar

// data class gives ==, hashCode, copy and toString for free.
data class User(
    val name: String,
    val age: Int,
)

fun main() {
    val u = User("Ada", 36)
    val same = User("Ada", 36)
    println(u) // User(name=Ada, age=36)
    println("u == same: ${u == same}") // true: compares the fields
    println("u === same: ${u === same}") // false: two objects
    println(u.copy(age = 37))
}
