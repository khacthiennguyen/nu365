class SecurityState {}

class SecurityInitial extends SecurityState {}

class SecutiryIsLoading extends SecurityState {}

class AuthenticatingState extends SecurityState {}

class SecurityIsLoaded extends SecurityState {
  final bool biometricEnabled;
  final bool twoFactorEnabled;

  SecurityIsLoaded(
      {required this.biometricEnabled, required this.twoFactorEnabled});
}

class SecurityIsLoadingFailure extends SecurityState {
  final String message;
  SecurityIsLoadingFailure({
    required this.message,
  });
}

class EnableTwoFactor extends SecurityState {
  final String secret;
  EnableTwoFactor({
    required this.secret,
  });
}

class DisableTwoFactorSuccess extends SecurityState {}

class EnableTwoFactorSuccess extends SecurityState {}
