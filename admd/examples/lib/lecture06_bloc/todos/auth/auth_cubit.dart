import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_state.dart';

export 'auth_state.dart';

// A stand-in for real authentication, which is Lecture 10. Any name signs in,
// an empty one fails.
class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthSignedOut());

  Future<void> signIn(String name) async {
    emit(const AuthSigningIn());
    await Future.delayed(const Duration(milliseconds: 500));
    if (name.trim().isEmpty) {
      emit(const AuthSignedOut(error: 'Enter a name to sign in'));
    } else {
      emit(AuthSignedIn(name.trim()));
    }
  }

  void signOut() => emit(const AuthSignedOut());
}
