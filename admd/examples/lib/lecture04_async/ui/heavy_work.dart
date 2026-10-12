import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'parse_photos.dart';

const _n = 3000000000;

// This function is async. It still freezes the UI: the loop never yields.
Future<int> sumTo(int n) async {
  return sumToSync(n);
}

// Top-level, so compute() can send it to another isolate.
int sumToSync(int n) {
  var total = 0;
  for (var i = 0; i < n; i++) {
    total += i; // pure CPU work
  }
  return total;
}

// Asynchrony and parallelism. Watch the spinner: it stops while the sum runs on the
// UI thread, and keeps turning while compute() runs the same sum on another isolate.
class HeavyWorkPage extends StatefulWidget {
  const HeavyWorkPage({super.key});

  @override
  State<HeavyWorkPage> createState() => _HeavyWorkPageState();
}

class _HeavyWorkPageState extends State<HeavyWorkPage> {
  String _result = 'Nothing computed yet.';
  bool _busy = false;

  Future<void> _run(String label, Future<Object> Function() work) async {
    setState(() {
      _busy = true;
      _result = '$label: working';
    });
    // Lets the frame with "working" reach the screen before the work starts.
    await Future.delayed(const Duration(milliseconds: 100));
    final watch = Stopwatch()..start();
    final total = await work();
    if (!mounted) return;
    setState(() {
      _busy = false;
      _result = '$label: $total in ${watch.elapsedMilliseconds} ms';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('compute() for heavy work')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 24),
            Text(_result),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _busy
                  ? null
                  : () => _run('await sumTo', () => sumTo(_n)),
              child: const Text('await sumTo(n) on the UI thread'),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _busy
                  ? null
                  : () => _run('compute', () => compute(sumToSync, _n)),
              child: const Text('compute(sumToSync, n)'),
            ),
            const SizedBox(height: 12),
            // I/O with await, then parsing with compute().
            OutlinedButton(
              onPressed: _busy
                  ? null
                  : () => _run(
                      'fetchPhotos',
                      () async => '${(await fetchPhotos()).length} photos',
                    ),
              child: const Text('fetchPhotos(): await, then compute'),
            ),
          ],
        ),
      ),
    );
  }
}
