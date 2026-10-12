import 'package:flutter/widgets.dart';

// An InheritedWidget makes a value readable by any descendant, without passing it
// through the constructors in between.
class TargetScope extends InheritedWidget {
  const TargetScope({super.key, required this.target, required super.child});

  final double target;

  // Reading through this method registers the caller as a dependent:
  // it rebuilds when the target changes.
  static double of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<TargetScope>()!.target;

  // Called when a new TargetScope replaces the old one. false means dependents are left alone.
  @override
  bool updateShouldNotify(TargetScope old) => old.target != target;
}
