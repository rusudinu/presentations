// Control flow and collection operators: collection-if, collection-for, spread.
// Run: dart run lib/lecture02_dart/basics/collection_operators.dart

List<String> buildMenu({required bool isAdmin, required List<String> topics}) {
  // Collection-if and collection-for build a list inline, with no helper method.
  // A Flutter build method fills a children: [...] list the same way.
  return ['Home', if (isAdmin) 'Admin', for (final t in topics) 'Lab: $t'];
}

void main() {
  final topics = ['Dart', 'Kotlin', 'Swift'];

  print(buildMenu(isAdmin: true, topics: topics));
  print(buildMenu(isAdmin: false, topics: topics));

  topics.where((t) => t.length > 4).forEach(print);

  // The spread operator inserts every element of another collection.
  final extra = ['Settings', 'About'];
  print([...buildMenu(isAdmin: false, topics: []), ...extra]);

  // for, if and while read like Kotlin and Java.
  var total = 0;
  for (var i = 1; i <= 4; i++) {
    if (i.isEven) total += i;
  }
  while (total < 10) {
    total += 3;
  }
  print(total);
}
