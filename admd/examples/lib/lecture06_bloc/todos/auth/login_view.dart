import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_cubit.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key, this.busy = false});

  final bool busy;

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16),
            if (widget.busy)
              const CircularProgressIndicator()
            else
              FilledButton(
                // read in a callback: the instance, no subscription.
                onPressed: () =>
                    context.read<AuthCubit>().signIn(_controller.text),
                child: const Text('Sign in'),
              ),
          ],
        ),
      ),
    );
  }
}
