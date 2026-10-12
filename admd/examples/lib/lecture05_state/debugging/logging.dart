import 'package:flutter/material.dart';

// print, debugPrint, assert, and the three debug switches. Watch the console.
class LoggingPage extends StatefulWidget {
  const LoggingPage({super.key});

  @override
  State<LoggingPage> createState() => _LoggingPageState();
}

class _LoggingPageState extends State<LoggingPage> {
  int _count = 0;

  @override
  void dispose() {
    // A global switch: turn it off when leaving, or every screen keeps logging.
    debugPrintRebuildDirtyWidgets = false;
    super.dispose();
  }

  void _logLongLine() {
    final x = 'x' * 5000;
    print('print: $x'); // Android's logcat cuts a line this long
    debugPrint('debugPrint: $x'); // throttled, so nothing is dropped
  }

  void _decrement() {
    setState(() => _count--);
    // Checked in debug builds only. Release builds compile the whole line out.
    assert(_count >= 0, 'count negative');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('print, debugPrint, and assert')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('count: $_count'),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: _logLongLine,
            child: const Text('Log a 5000 character line both ways'),
          ),
          OutlinedButton(
            onPressed: _decrement,
            child: const Text('Decrement: the assert fails below zero'),
          ),
          OutlinedButton(
            onPressed: () => setState(() => _count = 0),
            child: const Text('Reset the count'),
          ),
          const Divider(height: 32),
          OutlinedButton(
            onPressed: debugDumpApp,
            child: const Text('debugDumpApp(): the widget tree'),
          ),
          OutlinedButton(
            onPressed: debugDumpRenderTree,
            child: const Text('debugDumpRenderTree(): sizes and constraints'),
          ),
          SwitchListTile(
            title: const Text('debugPrintRebuildDirtyWidgets'),
            subtitle: const Text('Logs every widget that rebuilds'),
            value: debugPrintRebuildDirtyWidgets,
            onChanged: (value) =>
                setState(() => debugPrintRebuildDirtyWidgets = value),
          ),
        ],
      ),
    );
  }
}
