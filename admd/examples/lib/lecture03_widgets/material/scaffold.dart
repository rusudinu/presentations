import 'package:flutter/material.dart';

// One Scaffold per screen: app bar, body, floating action button, drawer, navigation bar.
// Every slot is optional.
class ScaffoldPage extends StatefulWidget {
  const ScaffoldPage({super.key});

  @override
  State<ScaffoldPage> createState() => _ScaffoldPageState();
}

class _ScaffoldPageState extends State<ScaffoldPage> {
  static const _destinations = ['Todos', 'Calendar', 'Settings'];

  int _selected = 0; // the selected index is state
  int _added = 0;

  void _addTodo() => setState(() => _added++);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // The back button appears on its own because this route can pop.
        // With a drawer, the AppBar shows the drawer handle in that place instead.
        title: Text(_destinations[_selected]),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () {},
          ),
        ],
      ),
      // A side panel for secondary destinations.
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            children: [
              const ListTile(title: Text('Secondary destinations')),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('About'),
                onTap: () => Navigator.of(context).pop(), // closes the drawer
              ),
              ListTile(
                leading: const Icon(Icons.arrow_back),
                title: const Text('Back to the examples'),
                onTap: () => Navigator.of(context)
                  ..pop()
                  ..pop(),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Text('${_destinations[_selected]}: $_added items added'),
      ),
      // One primary action per screen.
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        child: const Icon(Icons.add),
      ),
      // The Material 3 bottom bar: three to five destinations, one selected index.
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selected,
        onDestinationSelected: (index) => setState(() => _selected = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.checklist), label: 'Todos'),
          NavigationDestination(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
