import 'package:flutter/material.dart';

const d = Duration(milliseconds: 200); // one place, whole app

// Implicit animations: change a value, and the widget tweens from old to new.
class ImplicitAnimationsPage extends StatefulWidget {
  const ImplicitAnimationsPage({super.key});

  @override
  State<ImplicitAnimationsPage> createState() => _ImplicitAnimationsPageState();
}

class _ImplicitAnimationsPageState extends State<ImplicitAnimationsPage> {
  bool _done = false;
  bool _loading = false;
  int _items = 3;

  Future<void> _reload() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() {
      _loading = false;
      _items++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Implicit animations')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('done'),
            value: _done,
            onChanged: (v) => setState(() => _done = v),
          ),
          // Tweens color and padding.
          AnimatedContainer(
            duration: d,
            curve: Curves.easeOut,
            color: _done ? cs.primaryContainer : cs.surfaceContainerHighest,
            padding: EdgeInsets.all(_done ? 8 : 16),
            child: const Text('AnimatedContainer'),
          ),
          const SizedBox(height: 12),
          // Opacity zero still takes its space and still receives taps.
          AnimatedOpacity(
            duration: d,
            opacity: _done ? 0.3 : 1,
            child: const Text('AnimatedOpacity'),
          ),
          SizedBox(
            height: 40,
            child: AnimatedAlign(
              duration: d,
              alignment: _done ? Alignment.centerRight : Alignment.centerLeft,
              child: const Text('AnimatedAlign'),
            ),
          ),
          AnimatedDefaultTextStyle(
            duration: d,
            style: (_done ? tt.titleLarge! : tt.bodyMedium!).copyWith(
              decoration: _done ? TextDecoration.lineThrough : null,
            ),
            child: const Text('AnimatedDefaultTextStyle'),
          ),
          const SizedBox(height: 12),
          // Any value that can be tweened, with no State of your own.
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 300),
            tween: Tween(end: _done ? 1.0 : 0.25),
            builder: (context, value, _) =>
                LinearProgressIndicator(value: value),
          ),
          const Divider(height: 32),
          FilledButton(
            onPressed: _loading ? null : _reload,
            child: const Text('Reload the list'),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 60,
            // Cross-fades when the child's key changes.
            child: _RespectReducedMotion(
              child: AnimatedSwitcher(
                duration: d,
                child: _loading
                    ? const Center(
                        key: ValueKey('spin'),
                        child: CircularProgressIndicator(),
                      )
                    : Center(
                        key: ValueKey(_items),
                        child: Text('$_items items'),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Reduced motion: when the user turned animations off in the system settings,
// hand the content over without the transition.
class _RespectReducedMotion extends StatelessWidget {
  const _RespectReducedMotion({required this.child});

  final AnimatedSwitcher child;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return child.child!;
    return child;
  }
}
