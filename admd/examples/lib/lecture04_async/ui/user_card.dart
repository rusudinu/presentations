import 'package:flutter/material.dart';

import '../fake_api.dart';

class UserCard extends StatelessWidget {
  const UserCard({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.person),
        title: Text(user.name),
        subtitle: Text('id ${user.id}'),
      ),
    );
  }
}
