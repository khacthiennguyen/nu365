sealed class AuthenticateState {}

class AuthenticateIdle extends AuthenticateState {
  AuthenticateIdle();
}

class AuthenticateAuthenticated extends AuthenticateState {
  final String accessToken;
  AuthenticateAuthenticated({required this.accessToken});
}

class AuthenticateUnauthenticated extends AuthenticateState {}

class AuthenticateError extends AuthenticateState {}
