import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

// Value equality and rebuilds. A ValueNotifier asks the question every state consumer
// asks: is this state different from the last one? It notifies only when == says yes.
class ValueEqualityRebuildsPage extends StatefulWidget {
  const ValueEqualityRebuildsPage({super.key});

  @override
  State<ValueEqualityRebuildsPage> createState() =>
      _ValueEqualityRebuildsPageState();
}

class _PlainState {
  const _PlainState(this.count);

  final int count;
}

class _EquatableState extends Equatable {
  const _EquatableState(this.count);

  final int count;

  @override
  List<Object?> get props => [count];
}

class _MutableState {
  int count = 0;
}

class _ValueEqualityRebuildsPageState extends State<ValueEqualityRebuildsPage> {
  final _plain = ValueNotifier(const _PlainState(0));
  final _equatable = ValueNotifier(const _EquatableState(0));
  final _mutable = ValueNotifier(_MutableState());

  @override
  void dispose() {
    _plain.dispose();
    _equatable.dispose();
    _mutable.dispose();
    super.dispose();
  }

  // A new state object with the same count as the current one.
  void _emitSameValue() {
    _plain.value = _PlainState(_plain.value.count);
    _equatable.value = _EquatableState(_equatable.value.count);
  }

  void _emitNextValue() {
    _plain.value = _PlainState(_plain.value.count + 1);
    _equatable.value = _EquatableState(_equatable.value.count + 1);
  }

  // The mirror failure: change the object in place and emit the same instance.
  void _mutateInPlace() {
    final state = _mutable.value;
    state.count++;
    _mutable.value = state;
    debugPrint('the mutable count is now ${state.count}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Value equality and rebuilds')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Wrap(
            spacing: 8,
            children: [
              FilledButton(
                onPressed: _emitSameValue,
                child: const Text('Emit the same count again'),
              ),
              OutlinedButton(
                onPressed: _emitNextValue,
                child: const Text('Emit count + 1'),
              ),
            ],
          ),
          // Identity equality: rebuilds although nothing changed.
          _Consumer<_PlainState>(
            title: 'Without Equatable',
            notifier: _plain,
            describe: (state) => 'count ${state.count}',
          ),
          // Value equality: an equal state is ignored.
          _Consumer<_EquatableState>(
            title: 'With Equatable',
            notifier: _equatable,
            describe: (state) => 'count ${state.count}',
          ),
          const Divider(height: 32),
          FilledButton(
            onPressed: _mutateInPlace,
            child: const Text('Mutate in place, emit the same instance'),
          ),
          // The count changes, the screen does not. The console shows the real value.
          _Consumer<_MutableState>(
            title: 'Mutable state',
            notifier: _mutable,
            describe: (state) => 'count ${state.count}',
          ),
        ],
      ),
    );
  }
}

class _Consumer<T> extends StatefulWidget {
  const _Consumer({
    required this.title,
    required this.notifier,
    required this.describe,
  });

  final String title;
  final ValueNotifier<T> notifier;
  final String Function(T) describe;

  @override
  State<_Consumer<T>> createState() => _ConsumerState<T>();
}

class _ConsumerState<T> extends State<_Consumer<T>> {
  int _builds = 0;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<T>(
      valueListenable: widget.notifier,
      builder: (context, state, _) {
        _builds++;
        return ListTile(
          title: Text('${widget.title}: ${widget.describe(state)}'),
          trailing: Text('built $_builds times'),
        );
      },
    );
  }
}
