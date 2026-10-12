import 'package:flutter/material.dart';

// Shows how many times it was built. Used by the lecture 5 screens to make rebuilds visible.
class BuildProbe extends StatefulWidget {
  const BuildProbe(this.label, {super.key});

  final String label;

  @override
  State<BuildProbe> createState() => _BuildProbeState();
}

class _BuildProbeState extends State<BuildProbe> {
  int _builds = 0;

  @override
  Widget build(BuildContext context) {
    _builds++;
    return ListTile(
      dense: true,
      title: Text(widget.label),
      trailing: Text('built $_builds times'),
    );
  }
}
