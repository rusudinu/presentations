// Collections: List, Set and Map.
// Run: dart run lib/lecture02_dart/basics/collections.dart

void main() {
  final topics = ['Dart', 'Kotlin']; // List<String>, inferred from the contents
  final seen = <String>{}; // an empty literal has nothing to infer from
  final points = {'exam': 3, 'lab': 3}; // Map<String, int>

  for (final t in topics) {
    seen.add(t);
  }
  seen.add('Dart'); // a Set ignores duplicates
  print('seen: $seen');

  // List: ordered, indexed.
  topics.add('Swift');
  print('first: ${topics.first}, at 1: ${topics[1]}, length: ${topics.length}');

  // Map: a missing key reads as null, so the lookup type is int?.
  final int? bonus = points['bonus'];
  print('bonus: $bonus, exam: ${points['exam']}');
  points['project'] = 4;
  for (final MapEntry(:key, :value) in points.entries) {
    print('  $key: $value');
  }

  // where and map are lazy Iterable operations: nothing runs until someone iterates.
  final shouted = topics
      .where((t) {
        print('  checking $t');
        return t.length > 4;
      })
      .map((t) => t.toUpperCase());
  print('nothing checked yet');

  // toList() iterates and gives a List back.
  final List<String> result = shouted.toList();
  print(result);
}
