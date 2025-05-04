import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nu365/features/profile/logic/settings_event.dart';
import 'package:nu365/features/profile/logic/settings_state.dart';
import 'package:nu365/features/profile/services/settings_services.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsInitial()) {
    on<LoadUserInfor>((event, emit) async {
      emit(SettingsLoading());
      emit(await SettingsServices().loadUserInfo());
    });

    on<UpdateUserInfor>((event, emit) async {
      emit(SettingsLoading());
      emit(await SettingsServices().updateUserInfo(event.userInfo));
    });
  }
}
