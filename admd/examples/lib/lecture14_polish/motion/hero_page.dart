import 'package:flutter/material.dart';

// Hero: the same tag on two routes, and the widget flies from one to the other.
class HeroPage extends StatelessWidget {
  const HeroPage({super.key});

  static const _todos = [(1, 'Buy milk'), (2, 'Write lab 7'), (3, 'Call home')];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hero transitions')),
      body: ListView(
        children: [
          for (final (id, title) in _todos)
            ListTile(
              // List screen.
              leading: Hero(tag: 'todo-$id', child: _TodoThumbnail(id, 20)),
              title: Text(title),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => _DetailPage(id: id, title: title),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DetailPage extends StatelessWidget {
  const _DetailPage({required this.id, required this.title});

  final int id;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        // Detail screen, same tag. The tag has to be unique within a route.
        child: Hero(tag: 'todo-$id', child: _TodoThumbnail(id, 96)),
      ),
    );
  }
}

class _TodoThumbnail extends StatelessWidget {
  const _TodoThumbnail(this.id, this.radius);

  final int id;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.primaries[id * 3 % Colors.primaries.length],
      child: Text('$id', style: TextStyle(fontSize: radius * 0.8)),
    );
  }
}
