import 'dart:async';

import 'package:flutter/material.dart';

import 'counter_field.dart';

// The State lifecycle: initState, didUpdateWidget, dispose. The log shows each call.
class LifecyclePage extends StatefulWidget {
  const LifecyclePage({super.key});

  @override
  State<LifecyclePage> createState() => _LifecyclePageState();
}

class _LifecyclePageState extends State<LifecyclePage> {
  final _log = <String>[];
  bool _shown = true;
  int _interval = 1;

  // The child reports from initState and dispose, where setState is not allowed,
  // so the log is updated after the current frame.
  void _record(String line) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _log.add(line));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('State object rules')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const CounterField(label: 'Type here, then hide the ticker'),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: [
              FilledButton(
                onPressed: () => setState(() => _shown = !_shown),
                child: Text(_shown ? 'Remove the ticker' : 'Insert the ticker'),
              ),
              OutlinedButton(
                onPressed: () =>
                    setState(() => _interval = _interval == 1 ? 2 : 1),
                child: const Text('Change its interval'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_shown) _Ticker(seconds: _interval, onEvent: _record),
          const Divider(height: 32),
          for (final line in _log.reversed.take(8)) Text(line),
        ],
      ),
    );
  }
}

class _Ticker extends StatefulWidget {
  const _Ticker({required this.seconds, required this.onEvent});

  final int seconds;
  final ValueChanged<String> onEvent;

  @override
  State<_Ticker> createState() => _TickerState();
}

class _TickerState extends State<_Ticker> {
  late Timer _timer;
  int _ticks = 0;

  @override
  void initState() {
    super.initState();
    widget.onEvent('initState: timer started');
    _start();
  }

  // The parent rebuilt with new constructor arguments. The State object is the same one.
  @override
  void didUpdateWidget(_Ticker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.seconds != widget.seconds) {
      widget.onEvent(
        'didUpdateWidget: ${oldWidget.seconds} s to ${widget.seconds} s',
      );
      _timer.cancel();
      _start();
    }
  }

  // Anything you create, you dispose. A timer left running would call setState
  // on a State that is no longer in the tree.
  @override
  void dispose() {
    _timer.cancel();
    widget.onEvent('dispose: timer cancelled');
    super.dispose();
  }

  void _start() {
    _timer = Timer.periodic(
      Duration(seconds: widget.seconds),
      (_) => setState(() => _ticks++),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text('Ticks: $_ticks, every ${widget.seconds} s');
  }
}
