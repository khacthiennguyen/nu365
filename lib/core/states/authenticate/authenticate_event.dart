sealed class AuthenticateEvent {}

class AuthenticateInitial extends AuthenticateEvent {}

class AuthenticateLoggedIn extends AuthenticateEvent {
  final String accessToken;
  AuthenticateLoggedIn(this.accessToken);
}

class AuthenticateLoggedOut extends AuthenticateEvent {}