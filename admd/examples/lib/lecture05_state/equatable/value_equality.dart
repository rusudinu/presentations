// Value equality: the Equatable pattern, and the two ways to get it wrong.
// Run: dart run lib/lecture05_state/equatable/value_equality.dart

import 'package:equatable/equatable.dart';

enum LoadStatus { loading, ready }

// Without Equatable: == compares identity.
class PlainCounterState {
  const PlainCounterState({required this.count, required this.status});

  final int count;
  final LoadStatus status;
}

// With Equatable: == and hashCode compare the values listed in props.
class CounterState extends Equatable {
  const CounterState({required this.count, required this.status});

  final int count;
  final LoadStatus status;

  @override
  List<Object?> get props => [count, status];
}

// The classic bug: a field was added and props was not updated.
class ForgetfulCounterState extends Equatable {
  const ForgetfulCounterState({required this.count, required this.status});

  final int count;
  final LoadStatus status;

  @override
  List<Object?> get props => [count];
}

void main() {
  // Built at run time, so these are two separate objects, the way states are in an app.
  PlainCounterState plain(int count) =>
      PlainCounterState(count: count, status: LoadStatus.ready);
  CounterState state(int count) =>
      CounterState(count: count, status: LoadStatus.ready);

  print('without Equatable: ${plain(1) == plain(1)}'); // false
  print('with Equatable:    ${state(1) == state(1)}'); // true
  print('different count:   ${state(1) == state(2)}'); // false
  print('usable in a Set:   ${{state(1), state(1)}.length} element');

  // The two states differ only in status, and compare equal: a consumer would
  // never rebuild when loading finishes.
  final loading = ForgetfulCounterState(count: 1, status: LoadStatus.loading);
  final ready = ForgetfulCounterState(count: 1, status: LoadStatus.ready);
  print('forgotten in props: ${loading == ready}'); // true, and wrong
}
