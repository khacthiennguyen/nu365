class SecurityEvent {}

class TakeStatusSecurityEventSendToken extends SecurityEvent {}

class ToggleTwoFactorEvent extends SecurityEvent {
  final String password;
  final String email;
  final String otp;
  ToggleTwoFactorEvent(
      {required this.password, required this.email, required this.otp});
}

class EnableTwoFactorEvent extends SecurityEvent {}
