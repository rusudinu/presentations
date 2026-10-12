import 'package:flutter/material.dart';

import '../composition/good/online_indicator.dart';

// A Stack paints its children on top of each other. The first child is at the bottom.
class StackPositionedAlignPage extends StatelessWidget {
  const StackPositionedAlignPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stack, Positioned and Align')),
      body: Center(
        // The Stack sizes itself to its largest child that is not Positioned: the avatar.
        child: ColoredBox(
          color: Colors.black12,
          child: Stack(
            children: [
              const CircleAvatar(
                radius: 60,
                child: Icon(Icons.person, size: 60),
              ), // painted first
              // Positioned pins a child to one or more edges.
              const Positioned(right: 4, bottom: 4, child: OnlineIndicator()),
              // Align places a child by a fraction of the parent box.
              // Positioned.fill gives it the whole Stack to align inside.
              Positioned.fill(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'online',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
