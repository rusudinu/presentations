import 'package:flutter/material.dart';

// Two classes, one widget. The State object survives every parent rebuild.
class CounterView extends StatefulWidget {
  const CounterView({super.key});

  @override
  State<CounterView> createState() => _CounterViewState();
}

class _CounterViewState extends State<CounterView> {
  int _count = 0; // the mutable state

  @override
  Widget build(BuildContext context) => TextButton(
    // setState changes the field and marks this element dirty.
    onPressed: () => setState(() => _count++),
    child: Text('Count: $_count'),
  );
}
