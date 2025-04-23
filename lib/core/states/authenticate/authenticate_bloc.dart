import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nu365/core/states/authenticate/authenticate_event.dart';
import 'package:nu365/core/states/authenticate/authenticate_state.dart';


class AuthenticateBloc extends Bloc<AuthenticateEvent, AuthenticateState> {
  AuthenticateBloc() : super(AuthenticateIdle()) {
    on<AuthenticateLoggedIn>((event, emit) => emit(AuthenticateAuthenticated(accessToken: event.accessToken)));
    on<AuthenticateLoggedOut>((event, emit) => emit(AuthenticateUnauthenticated()));
  }
}
