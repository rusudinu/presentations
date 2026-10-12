import 'package:flutter/material.dart';

import 'performance_overlay.dart';

// Frames and jank. Turn on the performance overlay, then cause a slow frame.
// Measure with flutter run --profile: debug-mode timings are meaningless.
class JankPage extends StatefulWidget {
  const JankPage({super.key});

  @override
  State<JankPage> createState() => _JankPageState();
}

class _JankPageState extends State<JankPage> {
  bool _expensiveBuild = false;
  int _taps = 0;

  // Burns the UI thread for roughly the given time.
  static void _block(Duration duration) {
    final watch = Stopwatch()..start();
    while (watch.elapsed < duration) {}
  }

  @override
  Widget build(BuildContext context) {
    // Expensive work inside build: every rebuild of this page pays for it.
    if (_expensiveBuild) _block(const Duration(milliseconds: 50));

    return Scaffold(
      appBar: AppBar(title: const Text('Frames and jank')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Something that needs a frame every 8 or 16 ms, so a missed one shows.
          const LinearProgressIndicator(),
          ValueListenableBuilder<bool>(
            valueListenable: showPerformanceOverlay,
            builder: (context, shown, _) => SwitchListTile(
              title: const Text('Performance overlay'),
              subtitle: const Text(
                'Top graph: raster thread. Bottom: UI thread',
              ),
              value: shown,
              onChanged: (value) => showPerformanceOverlay.value = value,
            ),
          ),
          SwitchListTile(
            title: const Text('50 ms of work inside build'),
            value: _expensiveBuild,
            onChanged: (value) => setState(() => _expensiveBuild = value),
          ),
          FilledButton(
            onPressed: () => setState(() => _taps++),
            child: Text('Rebuild this page ($_taps)'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => _block(const Duration(milliseconds: 300)),
            child: const Text('Block the UI thread for 300 ms'),
          ),
        ],
      ),
    );
  }
}
