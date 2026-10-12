import 'package:flutter/material.dart';

import 'app_theme.dart';

// Hard-coded colors against theme roles. Switch to dark mode and compare the two cards.
class ThemingPage extends StatelessWidget {
  const ThemingPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Read it in any widget, never re-declare it.
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Theming')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeMode,
            builder: (context, mode, _) => SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(value: ThemeMode.system, label: Text('System')),
                ButtonSegment(value: ThemeMode.light, label: Text('Light')),
                ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
              ],
              selected: {mode},
              onSelectionChanged: (s) => themeMode.value = s.first,
            ),
          ),
          const SizedBox(height: 16),
          Text('Hard-coded: wrong in dark mode', style: tt.labelLarge),
          Container(
            color: const Color(0xFFE8EAF6),
            padding: const EdgeInsets.all(16),
            child: const Text(
              'Total',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
          const SizedBox(height: 16),
          Text('From the theme: follows the mode', style: tt.labelLarge),
          Container(
            color: cs.primaryContainer,
            padding: const EdgeInsets.all(16),
            // Paint with a role, write with its "on" pair, and contrast is handled.
            child: Text(
              'Total',
              style: tt.titleMedium?.copyWith(color: cs.onPrimaryContainer),
            ),
          ),
          const SizedBox(height: 24),
          Text('Color roles', style: tt.titleMedium),
          const SizedBox(height: 8),
          _Role('primary', cs.primary, cs.onPrimary),
          _Role('primaryContainer', cs.primaryContainer, cs.onPrimaryContainer),
          _Role('secondary', cs.secondary, cs.onSecondary),
          _Role('tertiary', cs.tertiary, cs.onTertiary),
          _Role('surface', cs.surface, cs.onSurface),
          _Role('error', cs.error, cs.onError),
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(border: Border.all(color: cs.outline)),
            child: const Text('outline: borders and dividers'),
          ),
          const SizedBox(height: 24),
          Text('Component themes', style: tt.titleMedium),
          const SizedBox(height: 8),
          // No style here: the border and the button height come from appTheme.
          const TextField(decoration: InputDecoration(labelText: 'Text field')),
          const SizedBox(height: 12),
          FilledButton(onPressed: () {}, child: const Text('Filled button')),
          const SizedBox(height: 12),
          // Rare, and usually a smell: a role would have adapted on its own.
          Text(
            Theme.of(context).brightness == Brightness.dark
                ? 'brightness: dark'
                : 'brightness: light',
          ),
        ],
      ),
    );
  }
}

class _Role extends StatelessWidget {
  const _Role(this.name, this.color, this.onColor);

  final String name;
  final Color color;
  final Color onColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.all(12),
      child: Text(name, style: TextStyle(color: onColor)),
    );
  }
}
