// Sealed states: each state carries only the fields that exist in it, and a switch
// over them has to cover every case.
sealed class AuthState {
  const AuthState();
}

final class AuthSignedOut extends AuthState {
  const AuthSignedOut({this.error});

  // Set when the last sign-in attempt failed.
  final String? error;
}

final class AuthSigningIn extends AuthState {
  const AuthSigningIn();
}

final class AuthSignedIn extends AuthState {
  const AuthSignedIn(this.user);

  final String user;
}
