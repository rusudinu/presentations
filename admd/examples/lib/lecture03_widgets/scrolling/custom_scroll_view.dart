import 'package:flutter/material.dart';

// CustomScrollView: a collapsing header and a list that share one scroll.
// Its children are slivers, the pieces every scroll view is built from.
class CustomScrollViewPage extends StatelessWidget {
  const CustomScrollViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            pinned: true,
            expandedHeight: 180,
            flexibleSpace: FlexibleSpaceBar(title: Text('CustomScrollView')),
          ),
          // The sliver form of ListView.builder.
          SliverList.builder(
            itemCount: 100,
            itemBuilder: (context, i) => ListTile(title: Text('Row $i')),
          ),
        ],
      ),
    );
  }
}
