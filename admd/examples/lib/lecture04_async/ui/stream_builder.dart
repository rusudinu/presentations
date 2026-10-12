import 'package:flutter/material.dart';

import '../streams/ticker.dart';

// StreamBuilder subscribes when the widget is first built and cancels when it is removed.
class StreamBuilderPage extends StatefulWidget {
  const StreamBuilderPage({super.key});

  @override
  State<StreamBuilderPage> createState() => _StreamBuilderPageState();
}

class _StreamBuilderPageState extends State<StreamBuilderPage> {
  // Stored once, for the same reason as a Future: ticker() inside build would hand
  // StreamBuilder a new Stream on every rebuild, and the count would start over.
  final Stream<int> _ticks = ticker();
  int _rebuilds = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('StreamBuilder')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StreamBuilder<int>(
              stream: _ticks,
              initialData: 0, // covers the gap before the first event
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                return Text(
                  'Tick: ${snapshot.data}',
                  style: Theme.of(context).textTheme.headlineMedium,
                );
              },
            ),
            const SizedBox(height: 16),
            // Rebuilding the page does not restart the ticker.
            OutlinedButton(
              onPressed: () => setState(() => _rebuilds++),
              child: Text('Rebuild the page ($_rebuilds)'),
            ),
          ],
        ),
      ),
    );
  }
}
