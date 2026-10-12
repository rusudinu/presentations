import 'package:flutter/material.dart';

// Constraints go down, sizes go up, the parent sets position.
// Each box prints the constraints its parent gave it.
class ConstraintsPage extends StatelessWidget {
  const ConstraintsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Layout constraints')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('1. A tight parent: the child asks for 400 x 400'),
          // SizedBox passes tight constraints down, so the Container cannot be 400 wide.
          SizedBox(
            width: 220,
            height: 70,
            child: Container(
              width: 400,
              height: 400,
              color: Colors.amber,
              child: const _ConstraintsLabel(),
            ),
          ),
          const SizedBox(height: 16),
          const Text('2. A loose parent: the child asks for 220 x 70'),
          // Center loosens the constraints: any size from zero up to the space available.
          // The child picks 220 x 70, and Center decides where it sits.
          ColoredBox(
            color: Colors.black12,
            child: SizedBox(
              height: 110,
              child: Center(
                child: Container(
                  width: 220,
                  height: 70,
                  color: Colors.lightBlue,
                  child: const _ConstraintsLabel(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '3. No size requested: the child fills what it is offered',
          ),
          SizedBox(
            height: 70,
            child: Container(
              color: Colors.lightGreen,
              child: const _ConstraintsLabel(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConstraintsLabel extends StatelessWidget {
  const _ConstraintsLabel();

  @override
  Widget build(BuildContext context) {
    // LayoutBuilder hands the incoming constraints to its builder.
    return LayoutBuilder(
      builder: (context, constraints) => Center(
        child: Text(
          'w ${constraints.minWidth.round()} to ${constraints.maxWidth.round()}\n'
          'h ${constraints.minHeight.round()} to ${constraints.maxHeight.round()}',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
