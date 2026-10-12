import 'package:flutter/material.dart';

import '../state/build_probe.dart';
import 'target_scope.dart';
import 'target_widgets.dart';

// The prop drilling screen again, with a TargetScope above the subtree.
// The widgets in between are const and never rebuild. Only the reader does.
class InheritedWidgetPage extends StatefulWidget {
  const InheritedWidgetPage({super.key});

  @override
  State<InheritedWidgetPage> createState() => _InheritedWidgetPageState();
}

class _InheritedWidgetPageState extends State<InheritedWidgetPage> {
  double _target = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('InheritedWidget')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TargetInput(
              target: _target,
              onChanged: (v) => setState(() => _target = v),
            ),
            // The state still lives here. The scope only publishes it downward.
            TargetScope(target: _target, child: const _Dashboard()),
          ],
        ),
      ),
    );
  }
}

class _Dashboard extends StatelessWidget {
  const _Dashboard();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(padding: EdgeInsets.all(12), child: _ClimateSection()),
    );
  }
}

class _ClimateSection extends StatelessWidget {
  const _ClimateSection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Climate'),
        BuildProbe('This section, between owner and reader'),
        SizedBox(height: 8),
        _TargetReader(),
      ],
    );
  }
}

class _TargetReader extends StatelessWidget {
  const _TargetReader();

  @override
  Widget build(BuildContext context) {
    // No constructor argument: the value comes from the nearest TargetScope above.
    return TargetChart(target: TargetScope.of(context));
  }
}
