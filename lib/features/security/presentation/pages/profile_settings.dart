import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nu365/core/data/runtime/runtime_memory_storage.dart';
import 'package:nu365/features/security/logic/security_bloc.dart';
import 'package:nu365/features/security/logic/security_event.dart';
import 'package:nu365/features/security/logic/security_state.dart';
import 'package:nu365/features/security/presentation/widgets/settings_cart.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  // Dùng để cập nhật UI mà không cần chờ API
  bool? _latestTwoFactorStatus;
  bool? _latestBiometricStatus;  @override
  void initState() {
    super.initState();
    _latestTwoFactorStatus = null;
    _latestBiometricStatus = null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        // Tạo BLoC và lấy trạng thái ngay lập tức khi màn hình được mở
        final bloc = SecurityBloc()..add(TakeStatusSecurityEventSendToken());
        return bloc;
      },
      child: BlocListener<SecurityBloc, SecurityState>(
        listener: (context, state) {
          if (state is SecurityIsLoaded) {
            // Khi nhận được trạng thái mới từ API, reset các giá trị đã lưu tạm
            setState(() {
              _latestTwoFactorStatus = null;
              _latestBiometricStatus = null;
            });
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Cài đặt tài khoản",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SettingsCard(
                    title: 'Bảo mật tài khoản',
                    widgets: [
                      ListTile(
                        title: const Text("Xác thực 2 yếu tố"),
                        subtitle: BlocBuilder<SecurityBloc, SecurityState>(                          builder: (context, state) {
                            // Ưu tiên dùng giá trị mới nhất từ kết quả màn hình con nếu có
                            if (_latestTwoFactorStatus != null) {
                              return Text(_latestTwoFactorStatus! ? "Đang bật" : "Đang tắt");
                            }
                            
                            // Nếu không có kết quả từ màn hình con, dùng state hoặc bộ nhớ
                            final bool twoFactorEnabled =
                                (state is SecurityIsLoaded)
                                    ? state.twoFactorEnabled
                                    : (RuntimeMemoryStorage.get('twoFactorEnabled') ?? false);

                            return Text(twoFactorEnabled ? "Đang bật" : "Đang tắt");
                          },
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),                        onTap: () async {
                          // Sử dụng await để đợi màn hình xác thực 2 yếu tố hoàn thành
                          final result = await context.push<bool>('/two-factor-settings', extra: {
                            'twoFactorEnabled':
                                RuntimeMemoryStorage.get('twoFactorEnabled')
                          });
                          
                          if (result != null) {
                            // Cập nhật UI ngay lập tức với kết quả trả về
                            setState(() {
                              _latestTwoFactorStatus = result;
                            });
                          }
                          
                          // Vẫn refresh từ API để đảm bảo đồng bộ
                          context.read<SecurityBloc>().add(TakeStatusSecurityEventSendToken());
                        },
                      ),
                      const SizedBox(height: 12),
                      ListTile(
                        title: const Text("Xác thực sinh trắc học"),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        subtitle: BlocBuilder<SecurityBloc, SecurityState>(                          builder: (context, state) {
                            // Ưu tiên dùng giá trị mới nhất từ kết quả màn hình con nếu có
                            if (_latestBiometricStatus != null) {
                              return Text(_latestBiometricStatus! ? "Đang bật" : "Đang tắt");
                            }
                            
                            // Nếu không có kết quả từ màn hình con, dùng state hoặc bộ nhớ
                            final bool biometricEnabled =
                                (state is SecurityIsLoaded)
                                    ? state.biometricEnabled
                                    : (RuntimeMemoryStorage.get('biometricEnabled') ?? false);

                            return Text(biometricEnabled ? "Đang bật" : "Đang tắt");
                          },
                        ),                        onTap: () async {
                          // Sử dụng await để đợi màn hình xác thực sinh trắc học hoàn thành
                          final result = await context.push<bool>('/biometric-settings', extra: {
                            'biometricEnabled':
                                RuntimeMemoryStorage.get('biometricEnabled')
                          });
                          
                          if (result != null) {
                            // Cập nhật UI ngay lập tức với kết quả trả về
                            setState(() {
                              _latestBiometricStatus = result;
                            });
                          }

                          // Vẫn refresh từ API để đảm bảo đồng bộ
                          context.read<SecurityBloc>().add(TakeStatusSecurityEventSendToken());
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
