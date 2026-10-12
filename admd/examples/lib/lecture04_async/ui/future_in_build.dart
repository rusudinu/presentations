import 'package:flutter/material.dart';

import '../fake_api.dart';

// Creating the Future outside build. Press Rebuild: the left panel fetches again
// and flashes its spinner, the right panel keeps the Future it stored once.
class FutureInBuildPage extends StatefulWidget {
  const FutureInBuildPage({super.key});

  @override
  State<FutureInBuildPage> createState() => _FutureInBuildPageState();
}

class _FutureInBuildPageState extends State<FutureInBuildPage> {
  final _recreated = _CountingApi();
  final _stored = _CountingApi();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Creating the Future outside build')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FilledButton(
              onPressed: () => setState(() {}),
              child: const Text('Rebuild'),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _RecreatedEveryBuild(api: _recreated)),
                const SizedBox(width: 16),
                Expanded(child: _StoredOnce(api: _stored)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Counts the requests, so each panel can show how many it has made.
class _CountingApi {
  int calls = 0;

  Future<User> fetchUser() async {
    calls++;
    await Future.delayed(const Duration(milliseconds: 800));
    return loadUser('1');
  }
}

class _RecreatedEveryBuild extends StatelessWidget {
  const _RecreatedEveryBuild({required this.api});

  final _CountingApi api;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      // A new Future on every build: FutureBuilder starts over, and the app refetches.
      future: api.fetchUser(),
      builder: (context, snapshot) =>
          _Body('Recreated every build', snapshot, api.calls),
    );
  }
}

class _StoredOnce extends StatefulWidget {
  const _StoredOnce({required this.api});

  final _CountingApi api;

  @override
  State<_StoredOnce> createState() => _StoredOnceState();
}

class _StoredOnceState extends State<_StoredOnce> {
  // Runs once, when the State object is created.
  late final Future<User> _future = widget.api.fetchUser();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: _future,
      builder: (context, snapshot) =>
          _Body('Stored once', snapshot, widget.api.calls),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body(this.title, this.snapshot, this.calls);

  final String title;
  final AsyncSnapshot<User> snapshot;
  final int calls;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Text('fetchUser() calls: $calls'),
        const SizedBox(height: 8),
        SizedBox(
          height: 40,
          child: snapshot.connectionState == ConnectionState.waiting
              ? const CircularProgressIndicator()
              : Text(snapshot.data?.name ?? 'Error: ${snapshot.error}'),
        ),
      ],
    );
  }
}
