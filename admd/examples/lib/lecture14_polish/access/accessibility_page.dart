import 'package:flutter/material.dart';

// Accessibility: labels, tap targets, text scaling. Turn on TalkBack or VoiceOver
// and set the system font to its largest step before opening this screen.
class AccessibilityPage extends StatelessWidget {
  const AccessibilityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Accessibility')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Labels'),
          Row(
            children: [
              // Announced as "button" and nothing else.
              IconButton(icon: const Icon(Icons.delete), onPressed: () {}),
              const Text('no label'),
              const SizedBox(width: 24),
              // The tooltip is also the screen reader label.
              IconButton(
                icon: const Icon(Icons.delete),
                tooltip: 'Delete todo',
                onPressed: () {},
              ),
              const Text('tooltip'),
            ],
          ),
          const Divider(height: 32),
          const Text('One label for a drawing'),
          // A chart is many shapes with no meaning to a screen reader. One label
          // says what it shows, and the shapes are left out.
          Semantics(
            label: '3 of 7 done',
            child: ExcludeSemantics(
              child: Row(
                children: [
                  for (var i = 0; i < 7; i++)
                    Container(
                      width: 28,
                      height: 28,
                      margin: const EdgeInsets.all(2),
                      color: i < 3 ? cs.primary : cs.outlineVariant,
                    ),
                ],
              ),
            ),
          ),
          const Divider(height: 32),
          const Text('Tap targets'),
          Row(
            children: [
              // A 24 dp icon is a 24 dp target unless you say otherwise.
              GestureDetector(onTap: () {}, child: const Icon(Icons.star)),
              const Text(' 24 dp'),
              const SizedBox(width: 24),
              // IconButton pads the same icon to 48 dp.
              IconButton(
                icon: const Icon(Icons.star),
                tooltip: 'Add to favorites',
                onPressed: () {},
              ),
              const Text('48 dp'),
            ],
          ),
          const Divider(height: 32),
          const Text('Text scaling'),
          // A fixed height cuts the text off once the user enlarges it.
          Container(
            height: 24,
            color: cs.errorContainer,
            child: const Text('Fixed height of 24: clipped at large sizes'),
          ),
          const SizedBox(height: 8),
          // No height: the row grows and the text wraps.
          Container(
            color: cs.primaryContainer,
            padding: const EdgeInsets.all(8),
            child: const Text('No fixed height: grows with the text'),
          ),
          const Divider(height: 32),
          const Text('Color as the only signal'),
          Text('Password too short', style: TextStyle(color: cs.error)),
          Row(
            children: [
              Icon(Icons.error_outline, color: cs.error),
              const SizedBox(width: 8),
              Text(
                'Error: password too short',
                style: TextStyle(color: cs.error),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
