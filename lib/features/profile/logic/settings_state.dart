import 'package:nu365/features/profile/models/user_info.dart';

class SettingsState {}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class LoadInfoUserSuccess extends SettingsState {
  final UserInfo userInfo;
  LoadInfoUserSuccess({
    required this.userInfo,
  });
}

class LoadInfoUserFailure extends SettingsState {
  final String error;
  LoadInfoUserFailure({required this.error});
}
