import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Cupertino widgets mirror the iOS look. Adaptive constructors pick the platform look at run time.
class CupertinoAndAdaptivePage extends StatefulWidget {
  const CupertinoAndAdaptivePage({super.key});

  @override
  State<CupertinoAndAdaptivePage> createState() =>
      _CupertinoAndAdaptivePageState();
}

class _CupertinoAndAdaptivePageState extends State<CupertinoAndAdaptivePage> {
  bool _on = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cupertino and adaptive widgets')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Material'),
          Switch(value: _on, onChanged: (v) => setState(() => _on = v)),
          const SizedBox(height: 16),
          const Text('Cupertino'),
          Align(
            alignment: Alignment.centerLeft,
            child: CupertinoSwitch(
              value: _on,
              onChanged: (v) => setState(() => _on = v),
            ),
          ),
          const SizedBox(height: 16),
          // Material on Android, Cupertino on iOS and macOS.
          const Text('Adaptive: follows the platform this runs on'),
          Align(
            alignment: Alignment.centerLeft,
            child: Switch.adaptive(
              value: _on,
              onChanged: (v) => setState(() => _on = v),
            ),
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: CircularProgressIndicator.adaptive(),
          ),
          const SizedBox(height: 16),
          CupertinoButton.filled(
            onPressed: () => Navigator.of(context).push(
              CupertinoPageRoute<void>(
                builder: (_) => const _CupertinoScreen(),
              ),
            ),
            child: const Text('Open a Cupertino screen'),
          ),
        ],
      ),
    );
  }
}

// The Cupertino counterparts of Scaffold and AppBar.
class _CupertinoScreen extends StatelessWidget {
  const _CupertinoScreen();

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text('Cupertino')),
      child: Center(child: Text('CupertinoPageScaffold')),
    );
  }
}
