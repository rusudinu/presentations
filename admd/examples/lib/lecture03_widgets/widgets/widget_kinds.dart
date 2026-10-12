import 'package:flutter/material.dart';

// Structure, style and behavior are all widgets. There is no separate layout or style language.
class WidgetKindsPage extends StatefulWidget {
  const WidgetKindsPage({super.key});

  @override
  State<WidgetKindsPage> createState() => _WidgetKindsPageState();
}

class _WidgetKindsPageState extends State<WidgetKindsPage> {
  int _taps = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Everything is a widget')),
      // Structure: Center, Padding and Column are widgets.
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Style: Opacity, DecoratedBox and Transform are widgets.
              const Opacity(opacity: 0.4, child: Text('Opacity 0.4')),
              const SizedBox(height: 16),
              const DecoratedBox(
                decoration: BoxDecoration(color: Colors.amber),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('DecoratedBox'),
                ),
              ),
              const SizedBox(height: 24),
              Transform.rotate(angle: 0.2, child: const Text('Transform')),
              const SizedBox(height: 24),
              // Behavior: GestureDetector wraps interaction around any content.
              GestureDetector(
                onTap: () => setState(() => _taps++),
                child: Text('GestureDetector: tapped $_taps times'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
