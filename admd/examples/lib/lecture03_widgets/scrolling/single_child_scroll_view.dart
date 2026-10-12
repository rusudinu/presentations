import 'package:flutter/material.dart';

// SingleChildScrollView scrolls exactly one child, and builds all of it.
// Right for a long form, where every field must exist. Wrong for a feed.
class SingleChildScrollViewPage extends StatelessWidget {
  const SingleChildScrollViewPage({super.key});

  static const _labels = [
    'First name',
    'Last name',
    'Email',
    'Phone',
    'Street',
    'City',
    'County',
    'Postal code',
    'Country',
    'Notes',
  ];

  @override
  Widget build(BuildContext context) {
    final fields = [
      for (final label in _labels)
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: TextField(
            decoration: InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(),
            ),
          ),
        ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('SingleChildScrollView')),
      // One scrollable per axis per screen. A ListView inside this Column
      // would fail with an unbounded height error.
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: fields),
      ),
    );
  }
}
