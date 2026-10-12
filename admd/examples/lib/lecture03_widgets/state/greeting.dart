import 'package:flutter/material.dart';

// Stateless means it owns no state. It still rebuilds whenever its parent rebuilds.
class Greeting extends StatelessWidget {
  const Greeting({super.key, required this.name});

  final String name; // always final

  @override
  Widget build(BuildContext context) {
    return Text('Hello, $name');
  }
}
