import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nu365/core/data/local/data_security.dart';
import 'package:nu365/core/states/authenticate/authenticate_event.dart';
import 'package:nu365/core/states/authenticate/authenticate_state.dart';

class AuthenticateBloc extends Bloc<AuthenticateEvent, AuthenticateState> {
  final DataSecurity _dataSecurity = DataSecurity();

  AuthenticateBloc() : super(AuthenticateIdle()) {
    on<AuthenticateLoggedIn>((event, emit) =>
        emit(AuthenticateAuthenticated(accessToken: event.accessToken)));
    on<AuthenticateLoggedOut>((event, emit) async {
      // Clear biometric data when user logs out
      await _dataSecurity.clearBiometricData();
      emit(AuthenticateUnauthenticated());
    });
  }
}
