// The todos feature from lecture 6, in the folder structure from the slides:
// bloc/, data/, view/, with auth/ beside it and a Cubit version in cubit/.
// Run: flutter run -t lib/lecture06_bloc/todos/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth/auth_cubit.dart';
import 'auth/login_view.dart';
import 'bloc/todo_bloc.dart';
import 'data/todo_api.dart';
import 'data/todo_repository.dart';
import 'view/todo_page.dart';

void main() {
  runApp(const TodosApp());
}

class TodosApp extends StatelessWidget {
  const TodosApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Repositories at the app root, blocs below them. Each layer knows only the one below it.
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => TodoApi()),
        RepositoryProvider(
          create: (context) => TodoRepository(context.read<TodoApi>()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthCubit()),
          BlocProvider(
            create: (context) =>
                TodoBloc(context.read<TodoRepository>())
                  ..add(const TodosRequested()),
          ),
        ],
        child: MaterialApp(
          title: 'Todos',
          theme: ThemeData(colorSchemeSeed: Colors.indigo),
          home: const AuthGate(),
        ),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    // BlocConsumer: a listener and a builder on the same bloc.
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          current is AuthSignedOut && current.error != null,
      listener: (context, state) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text((state as AuthSignedOut).error!))),
      // No default case: add a state and this switch stops compiling until it is handled.
      builder: (context, state) => switch (state) {
        AuthSignedOut() => const LoginView(),
        AuthSigningIn() => const LoginView(busy: true),
        AuthSignedIn(:final user) => TodoPage(user: user),
      },
    );
  }
}
