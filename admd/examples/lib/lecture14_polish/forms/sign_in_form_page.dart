import 'package:flutter/material.dart';

import 'validators.dart';

// A form end to end: validation, keyboard and focus order, submit, and where each
// kind of error goes. The address taken@example.com produces the server error.
class SignInFormPage extends StatefulWidget {
  const SignInFormPage({super.key});

  @override
  State<SignInFormPage> createState() => _SignInFormPageState();
}

class _SignInFormPageState extends State<SignInFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _submitting = false;
  String? _serverError;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  // Stands in for the real call. "Email already registered" is not something a
  // validator can know: only the server does.
  Future<void> _signIn() async {
    await Future.delayed(const Duration(seconds: 1));
    if (_email.text.trim() == 'taken@example.com') {
      throw Exception('Email already registered');
    }
  }

  Future<void> _submit() async {
    if (_submitting) return; // a double tap must not send the form twice
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _submitting = true;
      _serverError = null;
    });
    try {
      await _signIn();
      if (!mounted) return;
      // A form that submits silently looks broken.
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Signed in')));
    } on Exception {
      if (!mounted) return;
      // The fields keep what the user typed.
      setState(() => _serverError = 'Email already registered');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final serverError = _serverError;

    return Scaffold(
      appBar: AppBar(title: const Text('Forms')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          // Validates a field once the user has touched it, not before.
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _email,
                focusNode: _emailFocus,
                keyboardType: TextInputType.emailAddress,
                // The keyboard's action key says "next" and moves to the password.
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
                // The message from the validator is shown under the field.
                validator: validateEmail,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _password,
                focusNode: _passwordFocus,
                obscureText: true,
                // On the last field the action key submits.
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
                validator: validatePassword,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              const SizedBox(height: 16),
              // A server error belongs near the button. An icon and a word carry
              // the meaning, so color is not the only signal.
              if (serverError != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text('Error: $serverError')),
                    ],
                  ),
                ),
              FilledButton(
                onPressed: _submitting ? null : _submit,
                child: Text(_submitting ? 'Signing in' : 'Sign in'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
