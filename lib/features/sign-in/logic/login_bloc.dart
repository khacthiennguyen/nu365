import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nu365/features/sign-in/logic/login_event.dart';
import 'package:nu365/features/sign-in/logic/login_state.dart';
import 'package:nu365/features/sign-in/services/authenticate_service.dart';


class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginSubmittedEvent>((event, emit) async {
      emit(LoginLoading());
      print(await AuthenticateService.login(event.username, event.password));
      emit(await AuthenticateService.login(event.username, event.password));
    });
  }
}
