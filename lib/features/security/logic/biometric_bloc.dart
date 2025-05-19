import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nu365/features/security/logic/biometric_event.dart';
import 'package:nu365/features/security/logic/biometric_state.dart';
import 'package:nu365/features/security/services/biometric_services.dart';

class BiometricBloc extends Bloc<BiometricEvent, BiometricState> {
  BiometricBloc() : super(BiometricStateInitial()) {
    on<RegisterBiometric>((event, emit) async {
      emit(BiometricStateLoading());
      emit(await BiometricServices.registerBiometric());
    });

    on<DisableBiometric>((event, emit) async {
      emit(BiometricStateLoading());

      emit(await BiometricServices.disableBiometric());
    });
  }
}
