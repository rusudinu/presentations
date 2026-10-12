import 'package:flutter/material.dart';

import '../fake_api.dart';
import 'user_card.dart';

// await inside a State: loading, data and error, with try, catch and finally.
class RefreshWithErrorsPage extends StatefulWidget {
  const RefreshWithErrorsPage({super.key});

  @override
  State<RefreshWithErrorsPage> createState() => _RefreshWithErrorsPageState();
}

class _RefreshWithErrorsPageState extends State<RefreshWithErrorsPage> {
  User? _user;
  String? _error;
  bool _loading = false;

  Future<void> _refresh(String id) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      _user = await loadUser(id);
    } on ApiException {
      // The failure you expect, by type.
      _error = 'Network error';
    } catch (e, stack) {
      // Anything else. An app sends this to Crashlytics.
      debugPrint('$e\n$stack');
      _error = 'Something went wrong';
    } finally {
      // The user may have left the screen during the await.
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _user;

    return Scaffold(
      appBar: AppBar(title: const Text('Handling errors around await')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              children: [
                FilledButton(
                  onPressed: _loading ? null : () => _refresh('1'),
                  child: const Text('Load user 1'),
                ),
                OutlinedButton(
                  onPressed: _loading ? null : () => _refresh('missing'),
                  child: const Text('Load a missing user'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_loading)
              const CircularProgressIndicator()
            else if (_error != null)
              Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              )
            else if (user != null)
              UserCard(user: user)
            else
              const Text('Nothing loaded yet.'),
          ],
        ),
      ),
    );
  }
}
