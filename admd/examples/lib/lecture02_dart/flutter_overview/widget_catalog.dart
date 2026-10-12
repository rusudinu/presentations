// The widget catalog: one screen with a widget from every group on the slide.
// Run: flutter run -t lib/lecture02_dart/flutter_overview/widget_catalog.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CatalogApp());
}

class CatalogApp extends StatelessWidget {
  const CatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Widget catalog', home: CatalogPage());
  }
}

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  bool _checked = false;
  bool _switched = true;

  @override
  Widget build(BuildContext context) {
    // Structure: Scaffold, AppBar, Drawer. The shell every screen sits in.
    return Scaffold(
      appBar: AppBar(title: const Text('Widget catalog')),
      drawer: const Drawer(
        child: SafeArea(child: ListTile(title: Text('Drawer'))),
      ),
      // Scrolling: ListView. GridView is the two-dimensional version.
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _Section('Layout'),
          // Layout: Container, Padding, Row, Column, Stack.
          Row(
            children: [
              Container(width: 56, height: 56, color: Colors.indigo),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text('Column, line 1'), Text('Column, line 2')],
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(width: 56, height: 56, color: Colors.amber),
                  const Text('Stack'),
                ],
              ),
            ],
          ),
          const _Section('Input'),
          // Input: TextField, Checkbox, ElevatedButton.
          const TextField(decoration: InputDecoration(labelText: 'TextField')),
          Row(
            children: [
              Checkbox(
                value: _checked,
                onChanged: (value) => setState(() => _checked = value ?? false),
              ),
              const Text('Checkbox'),
            ],
          ),
          const _Section('Feedback'),
          // Feedback: SnackBar, AlertDialog, Tooltip.
          Wrap(
            spacing: 8,
            children: [
              ElevatedButton(
                onPressed: () => ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('SnackBar'))),
                child: const Text('Show SnackBar'),
              ),
              ElevatedButton(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('AlertDialog'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ),
                child: const Text('Show AlertDialog'),
              ),
              const Tooltip(
                message: 'Tooltip: long-press or hover',
                child: Icon(Icons.info_outline),
              ),
            ],
          ),
          const _Section('Cupertino'),
          // Cupertino: the same ideas, styled for iOS.
          Row(
            children: [
              CupertinoSwitch(
                value: _switched,
                onChanged: (value) => setState(() => _switched = value),
              ),
              CupertinoButton(
                onPressed: () {},
                child: const Text('CupertinoButton'),
              ),
            ],
          ),
          const _Section('Scrolling'),
          // GridView inside a ListView: shrinkWrap gives it a finite height.
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: [
              for (var i = 1; i <= 8; i++)
                ColoredBox(
                  color: Colors.indigo.shade100,
                  child: Center(child: Text('$i')),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
