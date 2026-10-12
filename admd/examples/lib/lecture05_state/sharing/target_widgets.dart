import 'package:flutter/material.dart';

// The two children that share one value in the lecture 5 sharing examples.
// Neither knows about the other.

// Reports a new target upward through a callback.
class TargetInput extends StatelessWidget {
  const TargetInput({super.key, required this.target, required this.onChanged});

  final double target;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Slider(
      min: 10,
      max: 30,
      divisions: 20,
      label: target.round().toString(),
      value: target,
      onChanged: onChanged,
    );
  }
}

// Receives the target through its constructor.
class TargetChart extends StatelessWidget {
  const TargetChart({super.key, required this.target});

  final double target;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Target: ${target.round()} °C'),
        const SizedBox(height: 8),
        LinearProgressIndicator(value: (target - 10) / 20, minHeight: 12),
      ],
    );
  }
}
