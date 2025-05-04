import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nu365/core/data/runtime/runtime_memory_storage.dart';
import 'package:nu365/features/profile/models/user_info.dart';
import 'package:intl/intl.dart';

// Events
abstract class ProfileEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadProfileEvent extends ProfileEvent {}

class UpdateProfileEvent extends ProfileEvent {
  final UserInfo userInfo;

  UpdateProfileEvent(this.userInfo);

  @override
  List<Object> get props => [userInfo];
}

// States
abstract class ProfileState extends Equatable {
  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserInfo userInfo;

  ProfileLoaded(this.userInfo);

  @override
  List<Object> get props => [userInfo];
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
  }

  void _onLoadProfile(
      LoadProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      // Lấy thông tin user từ bộ nhớ
      final sessionInfo = RuntimeMemoryStorage.get('session');

      if (sessionInfo == null) {
        emit(ProfileError('Không tìm thấy thông tin người dùng'));
        return;
      }

      // Định dạng ngày tạo tài khoản
      String formattedCreatedAt = 'N/A';
      if (sessionInfo['created_at'] != null) {
        try {
          final createdDateTime = DateTime.parse(sessionInfo['created_at']);
          formattedCreatedAt = DateFormat('dd/MM/yyyy').format(createdDateTime);
        } catch (e) {
          formattedCreatedAt = sessionInfo['created_at'] ?? 'N/A';
        }
      }

      // Tạo model UserInfo từ dữ liệu session
      final userInfo = UserInfo(
        userId: sessionInfo['uId'] ?? '',
        email: sessionInfo['email'] ?? '',
        userName: sessionInfo['username'] ?? '',
        created_at: sessionInfo['created_at'] != null
            ? DateTime.parse(sessionInfo['created_at'])
            : DateTime.now(),
        dayofbirth: sessionInfo['dayofbirth'] != null &&
                sessionInfo['dayofbirth'] != 'NULL'
            ? DateTime.tryParse(sessionInfo['dayofbirth'])
            : null,
        createdAt: formattedCreatedAt,
      );

      emit(ProfileLoaded(userInfo));
    } catch (e) {
      emit(ProfileError('Lỗi khi tải thông tin: $e'));
    }
  }

  void _onUpdateProfile(
      UpdateProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      // Giả định việc gọi API để cập nhật thông tin user ở đây
      // Trong bài tập này, chúng ta giả lập việc cập nhật thành công
      await Future.delayed(const Duration(seconds: 1)); // Giả lập API call

      // Sau khi cập nhật thành công, trả về state với thông tin đã cập nhật
      emit(ProfileLoaded(event.userInfo));
    } catch (e) {
      emit(ProfileError('Lỗi khi cập nhật thông tin: $e'));
    }
  }
}
