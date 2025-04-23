
import 'package:nu365/features/sign-in/models/credentail.dart';

sealed class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final Credential credential;

  LoginSuccess({required this.credential});
}

class LoginToManyRequest extends LoginState {}

class Login2FARequired extends LoginState {
  final String email;
  final String password;

  Login2FARequired({required this.email, required this.password});
}

class LoginActiveRequired extends LoginState {
  final String email;
  final String password;

  LoginActiveRequired({required this.email, required this.password});
}

class LoginFailed extends LoginState {
  final Exception? error;
  final String? message;

  LoginFailed({this.error, this.message});
}
