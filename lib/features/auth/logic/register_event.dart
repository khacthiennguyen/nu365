// filepath: d:\nu365\lib\features\auth\logic\register_event.dart
sealed class RegisterEvent {}

class RegisterSubmittedEvent extends RegisterEvent {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;

  RegisterSubmittedEvent({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });
}
