import 'package:nu365/features/profile/models/user_info.dart';

class SettingsEvent {}

class LoadUserInfor extends SettingsEvent {}

class UpdateUserInfor extends SettingsEvent {
  final UserInfo userInfo;

  UpdateUserInfor(this.userInfo);
}
