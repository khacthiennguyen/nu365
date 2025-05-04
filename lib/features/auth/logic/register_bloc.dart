// filepath: d:\nu365\lib\features\auth\logic\register_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nu365/features/auth/logic/register_event.dart';
import 'package:nu365/features/auth/logic/register_state.dart';
import 'package:nu365/features/auth/services/authenticate_service.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterSubmittedEvent>((event, emit) async {
      // Validate password match
      if (event.password != event.confirmPassword) {
        emit(RegisterFailed(message: "Passwords do not match"));
        return;
      }

      emit(RegisterLoading());
      emit(await AuthenticateService.register(
        name: event.name,
        email: event.email,
        password: event.password,
      ));
    });
  }
}
