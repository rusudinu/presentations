import 'package:flutter/material.dart';

// Composition over inheritance: you do not subclass Text to give it padding and a border.
// You wrap it.
class CompositionWrappingPage extends StatelessWidget {
  const CompositionWrappingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Composition over inheritance')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
            ),
            // One widget, one job: this Padding is the space inside the border.
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Hello'),
            ),
          ),
        ),
      ),
    );
  }
}
