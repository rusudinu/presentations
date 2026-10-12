import 'package:flutter/material.dart';

// MediaQuery: what the device tells the app. Rotate the device, open the keyboard,
// change the system font size, and watch the values.
class MediaQueryPage extends StatelessWidget {
  const MediaQueryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Each of these rebuilds this widget only when that one value changes.
    // MediaQuery.of(context) would rebuild it on any change.
    final size = MediaQuery.sizeOf(context);
    final pad = MediaQuery.paddingOf(context);
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;
    final scaler = MediaQuery.textScalerOf(context);

    return Scaffold(
      appBar: AppBar(title: const Text('MediaQuery')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('size: ${size.width.round()} x ${size.height.round()}'),
          Text('padding: top ${pad.top.round()}, bottom ${pad.bottom.round()}'),
          Text('keyboard height: ${keyboard.round()}'),
          Text('a 16 px font is drawn at ${scaler.scale(16).round()} px'),
          Text('orientation: ${MediaQuery.orientationOf(context).name}'),
          const SizedBox(height: 16),
          const TextField(
            decoration: InputDecoration(labelText: 'Tap to open the keyboard'),
          ),
        ],
      ),
    );
  }
}
