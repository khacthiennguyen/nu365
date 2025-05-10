sealed class LoginEvent {}

class LoginSubmittedEvent extends LoginEvent {
  final String username;
  final String password;

  LoginSubmittedEvent({required this.username, required this.password});
}

class LoginWithOtpEvent extends LoginEvent {
  final String email;
  final String password;
  final String otp;

  LoginWithOtpEvent(
      {required this.email, required this.password, required this.otp});
}
