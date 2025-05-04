// filepath: d:\nu365\lib\features\auth\logic\register_state.dart

sealed class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {}

class RegisterToManyRequest extends RegisterState {}

class RegisterActivationRequired extends RegisterState {
  final String email;
  final String name;

  RegisterActivationRequired({required this.email, required this.name});
}

class RegisterFailed extends RegisterState {
  final Exception? error;
  final String? message;

  RegisterFailed({this.error, this.message});
}
