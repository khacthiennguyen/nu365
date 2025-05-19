class BiometricState {}

class BiometricStateInitial extends BiometricState {}

class BiometricStateLoading extends BiometricState {}

class BiometricStateLoaded extends BiometricState {
  final bool isBiometricEnabled;
  BiometricStateLoaded({required this.isBiometricEnabled});
}

class BiometricStateFailure extends BiometricState {
  final String message;
  BiometricStateFailure({required this.message});
}

class BiometricActivated extends BiometricState {}

class BiometricDeactive extends BiometricState {}
