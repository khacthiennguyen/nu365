import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nu365/core/constants/app_theme.dart';
import 'package:nu365/features/profile/logic/settings_bloc.dart';
import 'package:nu365/features/profile/logic/settings_event.dart';
import 'package:nu365/features/profile/logic/settings_state.dart';
import 'package:nu365/features/profile/models/user_info.dart';
import 'package:nu365/features/profile/presentation/widgets/nutrition_goals_section.dart';
import 'package:nu365/features/profile/presentation/widgets/personal_info_section.dart';
import 'package:nu365/features/profile/presentation/widgets/profile_header.dart';
import 'package:nu365/features/profile/presentation/widgets/save_button.dart';

class PersionalInfomation extends StatefulWidget {
  const PersionalInfomation({super.key});

  @override
  State<PersionalInfomation> createState() => _PersionalInfomationState();
}

class _PersionalInfomationState extends State<PersionalInfomation> {
  // Controller cho các trường thông tin
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();
  final TextEditingController _carbsController = TextEditingController();

  // Biến để lưu trữ thông tin người dùng hiện tại
  UserInfo? _currentUserInfo;

  // Biến để kiểm soát mode chỉnh sửa
  bool _isEditMode = false;
  DateTime? _selectedDate;

  // Tạo một instance của SettingsBloc
  late final SettingsBloc _settingsBloc;

  @override
  void initState() {
    super.initState();
    // Khởi tạo bloc trong initState
    _settingsBloc = SettingsBloc();
    // Gọi event để load thông tin user
    _settingsBloc.add(LoadUserInfor());
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _fatController.dispose();
    _carbsController.dispose();
    // Đóng bloc khi widget bị dispose
    _settingsBloc.close();
    super.dispose();
  }

  // Phương thức để cập nhật các controller từ dữ liệu người dùng
  void _updateControllers(UserInfo userInfo) {
    _userNameController.text = userInfo.userName;
    _emailController.text = userInfo.email;
    _caloriesController.text = userInfo.goal_calories?.toString() ?? '';
    _proteinController.text = userInfo.goal_protein?.toString() ?? '';
    _fatController.text = userInfo.goal_fat?.toString() ?? '';
    _carbsController.text = userInfo.goal_carbs?.toString() ?? '';
    _selectedDate = userInfo.dayofbirth;
    _currentUserInfo = userInfo;
  }

  // Phương thức để chuyển đổi giữa chế độ xem và chế độ chỉnh sửa
  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
      if (!_isEditMode && _currentUserInfo != null) {
        // Nếu thoát khỏi chế độ chỉnh sửa, khôi phục giá trị ban đầu
        _updateControllers(_currentUserInfo!);
      }
    });
  }

  // Phương thức lưu thông tin đã cập nhật
  void _saveUserInfo() {
    if (_currentUserInfo == null) return;

    // Tạo UserInfo mới với thông tin đã cập nhật
    final updatedUserInfo = UserInfo(
      userId: _currentUserInfo!.userId,
      email: _emailController.text,
      userName: _userNameController.text,
      created_at: _currentUserInfo!.created_at,
      dayofbirth: _selectedDate,
      goal_calories: _caloriesController.text.isNotEmpty
          ? double.tryParse(_caloriesController.text)
          : null,
      goal_protein: _proteinController.text.isNotEmpty
          ? double.tryParse(_proteinController.text)
          : null,
      goal_fat: _fatController.text.isNotEmpty
          ? double.tryParse(_fatController.text)
          : null,
      goal_carbs: _carbsController.text.isNotEmpty
          ? double.tryParse(_carbsController.text)
          : null,
      createdAt: _currentUserInfo!.createdAt,
    );

    // Gọi event cập nhật thông tin
    _settingsBloc.add(UpdateUserInfor(updatedUserInfo));

    // Thoát chế độ chỉnh sửa
    setState(() {
      _isEditMode = false;
      _currentUserInfo = updatedUserInfo;
    });

    // Hiển thị thông báo thành công
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Thông tin đã được cập nhật thành công!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  // Hiển thị hộp thoại chọn ngày
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryPurple,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _settingsBloc,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              BlocBuilder<SettingsBloc, SettingsState>(
                builder: (context, state) {
                  if (state is SettingsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is LoadInfoUserSuccess) {
                    if (!_isEditMode && _currentUserInfo == null) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _updateControllers(state.userInfo);
                      });
                    }
                    return _buildUserInfoContent(
                      context,
                      _isEditMode
                          ? _currentUserInfo ?? state.userInfo
                          : state.userInfo,
                    );
                  } else if (state is LoadInfoUserFailure) {
                    return Center(
                      child: Text('Lỗi: ${state.error ?? "Không xác định"}'),
                    );
                  }
                  return const Center(child: Text('Không có dữ liệu'));
                },
              ),
              
              // Nút quay lại ở góc trên bên trái
              Positioned(
                top: 16,
                left: 16,
                child: GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: AppTheme.primaryPurple,
                    ),
                  ),
                ),
              ),
              
              // Nút chỉnh sửa ở góc trên bên phải
              BlocBuilder<SettingsBloc, SettingsState>(
                builder: (context, state) {
                  if (state is LoadInfoUserSuccess) {
                    return Positioned(
                      top: 16,
                      right: 16,
                      child: GestureDetector(
                        onTap: () {
                          if (_isEditMode) {
                            _toggleEditMode();
                          } else {
                            _updateControllers(state.userInfo);
                            _toggleEditMode();
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isEditMode ? Icons.close : Icons.edit,
                            color: AppTheme.primaryPurple,
                          ),
                        ),
                      ));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: _isEditMode 
            ? SaveButton(onSave: _saveUserInfo)
            : null,
      ),
    );
  }

  Widget _buildUserInfoContent(BuildContext context, UserInfo userInfo) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16.0, 60.0, 16.0, 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sử dụng widget ProfileHeader
          ProfileHeader(
            userName: userInfo.userName,
            userId: userInfo.userId,
            createdAt: userInfo.createdAt,
            userNameController: _userNameController,
            isEditMode: _isEditMode,
          ),
          
          const SizedBox(height: 24),
          
          // Sử dụng widget PersonalInfoSection
          PersonalInfoSection(
            email: userInfo.email,
            dateOfBirth: _selectedDate,
            isEditMode: _isEditMode,
            emailController: _emailController,
            onSelectDate: () => _selectDate(context),
          ),
          
          const SizedBox(height: 24),
          
          // Sử dụng widget NutritionGoalsSection
          NutritionGoalsSection(
            goalCalories: userInfo.goal_calories,
            goalProtein: userInfo.goal_protein,
            goalFat: userInfo.goal_fat,
            goalCarbs: userInfo.goal_carbs,
            isEditMode: _isEditMode,
            caloriesController: _caloriesController,
            proteinController: _proteinController,
            fatController: _fatController,
            carbsController: _carbsController,
          ),
        ],
      ),
    );
  }
}
