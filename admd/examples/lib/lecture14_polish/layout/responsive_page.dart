import 'package:flutter/material.dart';

// LayoutBuilder and a breakpoint: one column below 600 wide, list and detail above it.
// Resize the window or rotate the device.
class ResponsivePage extends StatefulWidget {
  const ResponsivePage({super.key});

  @override
  State<ResponsivePage> createState() => _ResponsivePageState();
}

class _ResponsivePageState extends State<ResponsivePage> {
  static const _todos = ['Buy milk', 'Write lab 7', 'Call home'];
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final list = _TodoList(
      todos: _todos,
      selected: _selected,
      onSelected: (i) => setState(() => _selected = i),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('LayoutBuilder and breakpoints')),
      // SafeArea keeps content clear of the notch and the gesture areas.
      body: SafeArea(
        // LayoutBuilder gives the space this widget gets, which is what matters
        // in a split view. MediaQuery would give the size of the whole screen.
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) return list;
            return Row(
              children: [
                Expanded(flex: 2, child: list),
                const VerticalDivider(width: 1),
                Expanded(flex: 3, child: _TodoDetail(_todos[_selected])),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TodoList extends StatelessWidget {
  const _TodoList({
    required this.todos,
    required this.selected,
    required this.onSelected,
  });

  final List<String> todos;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (final (i, todo) in todos.indexed)
          ListTile(
            title: Text(todo),
            selected: i == selected,
            onTap: () => onSelected(i),
          ),
      ],
    );
  }
}

class _TodoDetail extends StatelessWidget {
  const _TodoDetail(this.todo);

  final String todo;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(todo, style: Theme.of(context).textTheme.headlineSmall),
    );
  }
}
