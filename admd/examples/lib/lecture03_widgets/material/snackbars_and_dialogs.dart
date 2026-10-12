import 'package:flutter/material.dart';

// A SnackBar reports what already happened. A dialog blocks until the user decides.
class SnackBarsAndDialogsPage extends StatefulWidget {
  const SnackBarsAndDialogsPage({super.key});

  @override
  State<SnackBarsAndDialogsPage> createState() =>
      _SnackBarsAndDialogsPageState();
}

class _SnackBarsAndDialogsPageState extends State<SnackBarsAndDialogsPage> {
  bool _deleted = false;

  void _restore() => setState(() => _deleted = false);

  void _delete() {
    setState(() => _deleted = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Todo deleted'),
        action: SnackBarAction(label: 'Undo', onPressed: _restore),
      ),
    );
  }

  Future<void> _confirmDelete() async {
    // showDialog returns a Future. It completes with whatever Navigator.pop was given,
    // or with null when the dialog is dismissed by tapping outside it.
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => const ConfirmDelete(),
    );
    // After an await, the widget may be gone. Check before using the context again.
    if (!mounted) return;
    if (ok == true) _delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SnackBars and dialogs')),
      body: Center(
        child: _deleted
            ? const Text('Nothing here. Use Undo on the SnackBar.')
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Write lab 3'),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: _delete,
                    child: const Text('Delete, with a SnackBar'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: _confirmDelete,
                    child: const Text('Delete, after a dialog'),
                  ),
                ],
              ),
      ),
    );
  }
}

class ConfirmDelete extends StatelessWidget {
  const ConfirmDelete({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete this todo?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
