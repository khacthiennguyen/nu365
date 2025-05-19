import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nu365/core/constants/app_theme.dart';
import 'package:nu365/core/data/local/data_security.dart';
import 'package:nu365/core/data/runtime/runtime_memory_storage.dart';
import 'package:nu365/features/security/logic/biometric_bloc.dart';
import 'package:nu365/features/security/logic/biometric_event.dart';
import 'package:nu365/features/security/logic/biometric_state.dart';
import 'package:nu365/features/security/presentation/widgets/biometric_info_card.dart';
import 'package:nu365/features/security/presentation/widgets/settings_cart.dart';
import 'package:nu365/features/security/presentation/widgets/settings_swtiches.dart';
import 'package:nu365/features/security/utils/biometric_auth_helper.dart';

class BiometricSettings extends StatefulWidget {
  final bool biometricEnabled;
  const BiometricSettings({super.key, required this.biometricEnabled});

  @override
  State<BiometricSettings> createState() => _BiometricSettingsState();
}

class _BiometricSettingsState extends State<BiometricSettings> {
  bool _currentBiometricStatus = false;

  @override
  void initState() {
    super.initState();
    _currentBiometricStatus = widget.biometricEnabled;
    _loadBiometricStatusFromStorage();
  }

  // Tải trạng thái sinh trắc học từ secure storage
  Future<void> _loadBiometricStatusFromStorage() async {
    try {
      final status = await DataSecurity().getBiometricStatus();
      final storedUserId = await DataSecurity().getBiometricUserId();
      final currentUserId = RuntimeMemoryStorage.getSession()?['uId'];

      // Chỉ sử dụng trạng thái nếu ID người dùng khớp
      if (mounted && currentUserId != null && storedUserId == currentUserId) {
        setState(() {
          _currentBiometricStatus = status;
          // Đồng bộ với RuntimeMemoryStorage
          RuntimeMemoryStorage.set('biometricEnabled', status);
        });
      }
    } catch (e) {
      print('Error loading biometric status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => BiometricBloc(),
      child: Builder(
        builder: (builderContext) {
          return WillPopScope(
            onWillPop: () async {
              // Return the current biometric status when going back
              final status = RuntimeMemoryStorage.get('biometricEnabled') ??
                  _currentBiometricStatus;
              context.pop(status);
              return false; // Prevent default back behavior
            },
            child: BlocConsumer<BiometricBloc, BiometricState>(
              listener: (context, state) {
                if (state is BiometricStateFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else if (state is BiometricActivated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Xác thực sinh trắc học đã được kích hoạt'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  // Store the activated status
                  RuntimeMemoryStorage.set('biometricEnabled', true);

                  // Lưu trạng thái và user ID vào secure storage
                  final userId = RuntimeMemoryStorage.getSession()?['uId'];
                  if (userId != null) {
                    BiometricAuthHelper.updateBiometricStatus(true, userId);
                  }

                  // Pass the result back when going back to the previous screen
                  if (context.canPop()) {
                    context.pop(true);
                  }
                } else if (state is BiometricDeactive) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Xác thực sinh trắc học đã được tắt'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  // Store the deactivated status
                  RuntimeMemoryStorage.set('biometricEnabled', false);

                  // Xóa trạng thái khỏi secure storage
                  final userId = RuntimeMemoryStorage.getSession()?['uId'];
                  if (userId != null) {
                    BiometricAuthHelper.updateBiometricStatus(false, userId);
                  }

                  // Pass the result back when going back to the previous screen
                  if (context.canPop()) {
                    context.pop(false);
                  }
                }
              },
              builder: (context, state) {
                bool isLoading = state is BiometricStateLoading;
                bool isEnabled = _currentBiometricStatus;

                if (state is BiometricActivated) {
                  isEnabled = true;
                  _currentBiometricStatus = true;
                } else if (state is BiometricDeactive) {
                  isEnabled = false;
                  _currentBiometricStatus = false;
                }

                return Scaffold(
                  appBar: AppBar(
                    title: const Text(
                      "Xác thực sinh trắc học",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  body: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 16.0),
                          child: Text(
                            'Cài đặt bảo mật',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SettingsCard(
                          widgets: [
                            SettingsSwitches(
                              title: 'Xác thực sinh trắc học',
                              description: isEnabled
                                  ? 'Sử dụng vân tay hoặc khuôn mặt để đăng nhập nhanh chóng'
                                  : 'Kích hoạt để đăng nhập nhanh hơn bằng sinh trắc học',
                              onChanged: isLoading
                                  ? null
                                  : (value) {
                                      if (value == true) {
                                        // Kích hoạt sinh trắc học
                                        BlocProvider.of<BiometricBloc>(context)
                                            .add(RegisterBiometric());
                                      } else {
                                        // Tắt sinh trắc học
                                        BlocProvider.of<BiometricBloc>(context)
                                            .add(DisableBiometric());
                                      }
                                    },
                              currentValue: isEnabled,
                              trailing: isLoading
                                  ? SizedBox(
                                      width:
                                          56, // Đủ rộng cho switch và loading indicator
                                      child: Stack(
                                        alignment: Alignment.centerRight,
                                        children: [
                                          // Hiển thị switch mờ khi đang loading
                                          Opacity(
                                            opacity: 0.5,
                                            child: Switch(
                                              value: isEnabled,
                                              onChanged: null,
                                              activeColor:
                                                  AppTheme.primaryPurple,
                                            ),
                                          ),
                                          // Hiển thị loading indicator phía trên
                                          Positioned(
                                            right: 16,
                                            child: SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.0,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(
                                                  AppTheme.primaryPurple,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : null,
                            ),
                          ],
                        ),

                        // Hiển thị thông tin bổ sung khi sinh trắc học được kích hoạt
                        if (isEnabled) ...[
                          BiometricInfoCard(
                            title: 'Đăng nhập nhanh hơn',
                            description:
                                'Sử dụng vân tay hoặc khuôn mặt để đăng nhập không cần nhập mật khẩu',
                            icon: Icons.speed,
                          ),
                          BiometricInfoCard(
                            title: 'Bảo mật cao',
                            description:
                                'Sinh trắc học giúp bảo vệ tài khoản của bạn khỏi truy cập trái phép',
                            icon: Icons.security,
                          ),
                        ] else if (!isLoading) ...[
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 24.0, left: 8.0, right: 8.0),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.fingerprint,
                                    size: 64,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Kích hoạt sinh trắc học để đăng nhập nhanh hơn',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
