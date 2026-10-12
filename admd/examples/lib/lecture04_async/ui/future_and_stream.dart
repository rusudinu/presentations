import 'package:flutter/material.dart';

// Combining a Future and a Stream: a Future for what is already true,
// a Stream for what keeps changing. Here: chat history, then new messages.
class FutureAndStreamPage extends StatefulWidget {
  const FutureAndStreamPage({super.key});

  @override
  State<FutureAndStreamPage> createState() => _FutureAndStreamPageState();
}

class _FutureAndStreamPageState extends State<FutureAndStreamPage> {
  late final Future<List<String>> _history = _loadHistory();
  late final Stream<List<String>> _incoming = _newMessages();

  static Future<List<String>> _loadHistory() async {
    await Future.delayed(const Duration(seconds: 1));
    return ['Ada: is the lab at 10?', 'Dinu: yes, room EC105'];
  }

  // Emits the list of messages received so far, one more every two seconds.
  static Stream<List<String>> _newMessages() async* {
    final received = <String>[];
    for (var i = 1; ; i++) {
      await Future.delayed(const Duration(seconds: 2));
      received.add('Ada: new message $i');
      yield List.of(received);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Combining a Future and a Stream')),
      // The Future: a spinner, then the initial data.
      body: FutureBuilder<List<String>>(
        future: _history,
        builder: (context, history) {
          if (history.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (history.hasError) {
            return Center(child: Text('Error: ${history.error}'));
          }
          // The Stream: new events update the same screen.
          return StreamBuilder<List<String>>(
            stream: _incoming,
            initialData: const [],
            builder: (context, incoming) {
              final messages = [...history.data!, ...incoming.data!];
              return ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, i) => ListTile(title: Text(messages[i])),
              );
            },
          );
        },
      ),
    );
  }
}
