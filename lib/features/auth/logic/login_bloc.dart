import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nu365/features/auth/logic/login_event.dart';
import 'package:nu365/features/auth/logic/login_state.dart';
import 'package:nu365/features/auth/services/authenticate_service.dart';


class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginSubmittedEvent>((event, emit) async {
      emit(LoginLoading());
      emit(await AuthenticateService.login(event.username, event.password));
    });
  }
}
