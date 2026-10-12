import 'package:flutter/material.dart';

import 'target_widgets.dart';

// Lifting state up: two widgets need the same value, so it moves to their nearest
// common ancestor. Data flows down as constructor arguments, events flow up as callbacks.
class LiftingStateUpPage extends StatefulWidget {
  const LiftingStateUpPage({super.key});

  @override
  State<LiftingStateUpPage> createState() => _LiftingStateUpPageState();
}

class _LiftingStateUpPageState extends State<LiftingStateUpPage> {
  double _target = 20;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Lifting state up')),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TargetInput(
            target: _target,
            onChanged: (v) => setState(() => _target = v),
          ),
          TargetChart(target: _target),
        ],
      ),
    ),
  );
}
