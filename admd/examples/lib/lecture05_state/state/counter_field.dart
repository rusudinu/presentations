import 'package:flutter/material.dart';

// The State object from the slide: it owns a controller and a count, and releases
// the controller in dispose.
class CounterField extends StatefulWidget {
  const CounterField({super.key, required this.label});

  final String label;

  @override
  State<CounterField> createState() => _CounterFieldState();
}

class _CounterFieldState extends State<CounterField> {
  final _controller = TextEditingController();
  int _count = 0;

  @override
  void dispose() {
    _controller.dispose(); // release what you created
    super.dispose();
  }

  void _increment() => setState(() => _count++);

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: TextField(
          controller: _controller,
          // The widget's fields are read through widget.something.
          decoration: InputDecoration(labelText: widget.label),
        ),
      ),
      const SizedBox(width: 12),
      Text('Count: $_count'),
      IconButton(onPressed: _increment, icon: const Icon(Icons.add)),
    ],
  );
}
