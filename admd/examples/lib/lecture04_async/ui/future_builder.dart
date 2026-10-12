import 'package:flutter/material.dart';

import '../fake_api.dart';
import 'user_card.dart';

// FutureBuilder turns one Future into a widget: waiting, then data or error.
class FutureBuilderPage extends StatefulWidget {
  const FutureBuilderPage({super.key});

  @override
  State<FutureBuilderPage> createState() => _FutureBuilderPageState();
}

class _FutureBuilderPageState extends State<FutureBuilderPage> {
  // Stored in the State, so a rebuild reuses it.
  late Future<User> _userFuture = _slowUser('1');

  static Future<User> _slowUser(String id) async {
    await Future.delayed(
      const Duration(seconds: 1),
    ); // long enough to see the spinner
    return loadUser(id);
  }

  // A reload is a new Future, assigned inside setState.
  void _load(String id) => setState(() => _userFuture = _slowUser(id));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FutureBuilder')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              children: [
                FilledButton(
                  onPressed: () => _load('1'),
                  child: const Text('Reload'),
                ),
                OutlinedButton(
                  onPressed: () => _load('missing'),
                  child: const Text('Reload with a failure'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            FutureBuilder<User>(
              future: _userFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                // Check hasError before reading data.
                if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                return UserCard(user: snapshot.data!);
              },
            ),
          ],
        ),
      ),
    );
  }
}
