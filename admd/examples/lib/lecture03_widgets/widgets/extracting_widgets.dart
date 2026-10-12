import 'package:flutter/material.dart';

import '../composition/bad/user_list_item.dart' as bad;
import '../composition/good/user_list_item.dart' as good;

// The same list item twice: one long build method, and small extracted widgets.
// Both look identical on screen. Read the two files side by side.
class ExtractingWidgetsPage extends StatelessWidget {
  const ExtractingWidgetsPage({super.key});

  static const _avatarUrl = 'https://i.pravatar.cc/120?img=5';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Extracting widgets')),
      backgroundColor: Colors.grey[200],
      body: ListView(
        children: const [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Text('composition/bad: one build method'),
          ),
          bad.UserListItem(
            name: 'Ada Lovelace',
            email: 'ada@example.com',
            avatarUrl: _avatarUrl,
            messageCount: 3,
            isOnline: true,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Text('composition/good: extracted widgets'),
          ),
          good.UserListItem(
            name: 'Ada Lovelace',
            email: 'ada@example.com',
            avatarUrl: _avatarUrl,
            messageCount: 3,
            isOnline: true,
          ),
        ],
      ),
    );
  }
}
