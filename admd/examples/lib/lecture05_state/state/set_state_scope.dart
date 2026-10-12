import 'package:flutter/material.dart';

import 'build_probe.dart';

// setState marks one Element dirty, and only that subtree builds again.
// Each row shows how many times it was built.
class SetStateScopePage extends StatefulWidget {
  const SetStateScopePage({super.key});

  @override
  State<SetStateScopePage> createState() => _SetStateScopePageState();
}

class _SetStateScopePageState extends State<SetStateScopePage> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('setState in detail')),
      body: ListView(
        children: [
          ListTile(
            title: Text('Page counter: $_count'),
            subtitle: const Text('setState at the top of the page'),
            trailing: FilledButton(
              onPressed: () => setState(() => _count++),
              child: const Text('+1'),
            ),
          ),
          // A new instance on every page build, so it builds again every time.
          // ignore: prefer_const_constructors -- the missing const is the point here
          BuildProbe('Child without const'),
          // The same instance on every page build: Flutter skips this subtree.
          const BuildProbe('Child with const'),
          const Divider(),
          // The same counter pushed down the tree. Its setState rebuilds only itself.
          const _LocalCounter(),
        ],
      ),
    );
  }
}

class _LocalCounter extends StatefulWidget {
  const _LocalCounter();

  @override
  State<_LocalCounter> createState() => _LocalCounterState();
}

class _LocalCounterState extends State<_LocalCounter> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Local counter: $_count'),
      subtitle: const Text('setState inside this row: no probe above moves'),
      trailing: FilledButton(
        onPressed: () => setState(() => _count++),
        child: const Text('+1'),
      ),
    );
  }
}
