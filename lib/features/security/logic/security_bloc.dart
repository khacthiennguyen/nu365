import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nu365/features/security/logic/security_event.dart';
import 'package:nu365/features/security/logic/security_state.dart';
import 'package:nu365/features/security/services/two_factor_services.dart';

class SecurityBloc extends Bloc<SecurityEvent, SecurityState> {
  SecurityBloc() : super(SecurityInitial()) {
    
    on<TakeStatusSecurityEventSendToken>((event, emit) async {
      emit(SecutiryIsLoading());
      emit(await SercurityServices.getSecurityStatus());
    });

    on<ToggleTwoFactorEvent>((event, emit) async {
      emit(SecutiryIsLoading());
      final result = await SercurityServices.toggleTwoFactor(
          email: event.email, password: event.password, otp: event.otp);

      emit(result);

      // Sau khi toggle xong, lấy lại trạng thái mới nhất từ server
      if (result is EnableTwoFactorSuccess ||
          result is DisableTwoFactorSuccess) {
        final latestState = await SercurityServices.getSecurityStatus();
        emit(latestState);
      }
    });

    on<EnableTwoFactorEvent>((event, emit) async {
      emit(SecutiryIsLoading());
      emit(await SercurityServices.enable2fa());
    });
  }
}
