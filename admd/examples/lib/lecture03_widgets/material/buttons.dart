import 'package:flutter/material.dart';

// The Material buttons, by how much attention each one asks for.
class ButtonsPage extends StatelessWidget {
  const ButtonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    void pressed(String name) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(name)));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buttons'),
        actions: [
          // IconButton is the button for bars.
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => pressed('IconButton'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // The main action of the screen.
            FilledButton(
              onPressed: () => pressed('FilledButton'),
              child: const Text('FilledButton'),
            ),
            const SizedBox(height: 12),
            // The rest.
            OutlinedButton(
              onPressed: () => pressed('OutlinedButton'),
              child: const Text('OutlinedButton'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => pressed('TextButton'),
              child: const Text('TextButton'),
            ),
            const SizedBox(height: 12),
            // onPressed: null disables any button.
            const FilledButton(onPressed: null, child: Text('Disabled')),
            const SizedBox(height: 24),
            // Colors and typography come from ThemeData, not from each widget.
            Text(
              'This text uses textTheme.titleLarge and colorScheme.primary',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => pressed('FloatingActionButton'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
