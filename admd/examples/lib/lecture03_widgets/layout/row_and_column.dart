import 'package:flutter/material.dart';

// Row and Column are the same widget on two axes. Change the settings and watch the children move.
class RowAndColumnPage extends StatefulWidget {
  const RowAndColumnPage({super.key});

  @override
  State<RowAndColumnPage> createState() => _RowAndColumnPageState();
}

class _RowAndColumnPageState extends State<RowAndColumnPage> {
  Axis _direction = Axis.vertical;
  MainAxisAlignment _main = MainAxisAlignment.center;
  CrossAxisAlignment _cross = CrossAxisAlignment.start;
  MainAxisSize _size = MainAxisSize.max;

  @override
  Widget build(BuildContext context) {
    const children = [
      Text('Todos'),
      SizedBox(width: 8, height: 8),
      Text('3 items left'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Row and Column')),
      body: Column(
        children: [
          SwitchListTile(
            title: Text(_direction == Axis.vertical ? 'Column' : 'Row'),
            value: _direction == Axis.vertical,
            onChanged: (vertical) => setState(
              () => _direction = vertical ? Axis.vertical : Axis.horizontal,
            ),
          ),
          SwitchListTile(
            title: Text('mainAxisSize: ${_size.name}'),
            value: _size == MainAxisSize.max,
            onChanged: (max) => setState(
              () => _size = max ? MainAxisSize.max : MainAxisSize.min,
            ),
          ),
          _Picker(
            label: 'mainAxisAlignment',
            value: _main,
            values: MainAxisAlignment.values,
            onChanged: (value) => setState(() => _main = value),
          ),
          _Picker(
            label: 'crossAxisAlignment',
            value: _cross,
            // baseline needs a textBaseline, so it is left out of the picker
            values: const [
              CrossAxisAlignment.start,
              CrossAxisAlignment.center,
              CrossAxisAlignment.end,
              CrossAxisAlignment.stretch,
            ],
            onChanged: (value) => setState(() => _cross = value),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              // Align lets the Row or Column be smaller than the gray area when it shrinks.
              child: ColoredBox(
                color: Colors.black12,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: ColoredBox(
                    color: Colors.amber,
                    // Row and Column are both a Flex with a fixed direction.
                    child: Flex(
                      direction: _direction,
                      mainAxisAlignment: _main,
                      crossAxisAlignment: _cross,
                      mainAxisSize: _size,
                      children: children,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Picker<T extends Enum> extends StatelessWidget {
  const _Picker({
    required this.label,
    required this.value,
    required this.values,
    required this.onChanged,
  });

  final String label;
  final T value;
  final List<T> values;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      trailing: DropdownButton<T>(
        value: value,
        items: [
          for (final v in values)
            DropdownMenuItem(value: v, child: Text(v.name)),
        ],
        onChanged: (v) {
          if (v != null) onChanged(v);
        },
      ),
    );
  }
}
