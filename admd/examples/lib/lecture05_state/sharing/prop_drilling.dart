import 'package:flutter/material.dart';

import 'target_widgets.dart';

// Prop drilling: the state was lifted to the page, and the chart sits three widgets
// below it. Every widget in between takes target only to pass it on.
// inherited_widget.dart is the same screen without the drilling.
class PropDrillingPage extends StatefulWidget {
  const PropDrillingPage({super.key});

  @override
  State<PropDrillingPage> createState() => _PropDrillingPageState();
}

class _PropDrillingPageState extends State<PropDrillingPage> {
  double _target = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lifting state up: the cost')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TargetInput(
              target: _target,
              onChanged: (v) => setState(() => _target = v),
            ),
            _Dashboard(target: _target),
          ],
        ),
      ),
    );
  }
}

class _Dashboard extends StatelessWidget {
  const _Dashboard({required this.target});

  final double target; // not used here, only passed on

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: _ClimateSection(target: target),
      ),
    );
  }
}

class _ClimateSection extends StatelessWidget {
  const _ClimateSection({required this.target});

  final double target; // not used here, only passed on

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Climate'),
        const SizedBox(height: 8),
        TargetChart(target: target),
      ],
    );
  }
}
