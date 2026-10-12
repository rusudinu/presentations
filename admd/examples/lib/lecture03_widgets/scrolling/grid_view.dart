import 'package:flutter/material.dart';

// GridView.builder is lazy in two dimensions: only visible cells are ever built.
class GridViewPage extends StatelessWidget {
  const GridViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GridView')),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.4,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount: 500,
        itemBuilder: (context, i) => _PhotoTile(i),
      ),
    );
  }
}

class _PhotoTile extends StatelessWidget {
  const _PhotoTile(this.index);

  final int index;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.primaries[index % Colors.primaries.length].shade200,
      child: Center(child: Text('Photo $index')),
    );
  }
}
