import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nu365/core/data/runtime/runtime_memory_storage.dart';
import 'package:nu365/features/security/logic/security_bloc.dart';
import 'package:nu365/features/security/logic/security_event.dart';
import 'package:nu365/features/security/logic/security_state.dart';
import 'package:nu365/features/security/presentation/widgets/settings_cart.dart';
import 'package:nu365/features/security/presentation/widgets/settings_swtiches.dart';
import 'package:url_launcher/url_launcher.dart';

class TwoFactorSettings extends StatefulWidget {
  final bool twoFactorEnabled;
  const TwoFactorSettings({super.key, required this.twoFactorEnabled});

  @override
  State<TwoFactorSettings> createState() => _TwoFactorSettingsState();
}

class _TwoFactorSettingsState extends State<TwoFactorSettings> {
  late bool _twoFactorEnabled;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final String email = RuntimeMemoryStorage.get('session')['email'];
  bool _obscurePassword = true;
  String? _secretKey; // Tạo URL cho ứng dụng xác thực
  String _createOtpAuthURL() {
    final String appName = "NU365";
    return Uri.encodeFull(
        "otpauth://totp/$appName:$email?secret=${_secretKey!}&issuer=$appName");
  }

  // Mở Google Authenticator trên Android
  void _openGoogleAuthenticator() {
    try {
      final String otpAuthURL = _createOtpAuthURL();
      final String googleAuthURL = otpAuthURL;
      launchUrl(Uri.parse(googleAuthURL), mode: LaunchMode.externalApplication)
          .catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  "Không tìm thấy Google Authenticator, vui lòng cài đặt ứng dụng.")),
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi: $e")),
      );
    }
  }

  // Hiển thị menu chọn ứng dụng trên iOS
  void _showAuthenticatorOptions() {
    final String otpAuthURL = _createOtpAuthURL();

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Chọn ứng dụng xác thực",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.security, color: Colors.blue),
                title: const Text("Google Authenticator"),
                subtitle: const Text("Ứng dụng xác thực phổ biến"),
                onTap: () {
                  Navigator.pop(context);
                  final url = "googleauthenticator://$otpAuthURL";
                  launchUrl(Uri.parse(url),
                      mode: LaunchMode.externalApplication);
                },
              ),
              ListTile(
                leading: const Icon(Icons.key, color: Colors.orange),
                title: const Text("Apple Keychain"),
                subtitle: const Text("Tích hợp với hệ thống iOS"),
                onTap: () {
                  Navigator.pop(context);
                  final url = "shortcuts://$otpAuthURL";
                  launchUrl(Uri.parse(url),
                      mode: LaunchMode.externalApplication);
                },
              ),
              ListTile(
                leading: const Icon(Icons.app_shortcut, color: Colors.purple),
                title: const Text("Ứng dụng khác"),
                subtitle: const Text("Mở với ứng dụng khác hỗ trợ OTP"),
                onTap: () {
                  Navigator.pop(context);
                  launchUrl(Uri.parse(otpAuthURL),
                      mode: LaunchMode.externalApplication);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _twoFactorEnabled = widget.twoFactorEnabled;
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _showToggle2FADialog(BuildContext context, SecurityBloc bloc) {
    // Reset controllers and password visibility when opening dialog
    _passwordController.clear();
    _otpController.clear();
    setState(() {
      _obscurePassword = true;
    });

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setDialogState) {
          return AlertDialog(
            title: Text(_twoFactorEnabled
                ? "Tắt xác thực 2 yếu tố"
                : "Bật xác thực 2 yếu tố"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                // Password field with toggle visibility
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: "Mật khẩu",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setDialogState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // OTP field with number input only and max length
                TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: InputDecoration(
                    labelText: "Mã OTP",
                    counterText: "", // Hide the counter
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Hủy"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_passwordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Vui lòng nhập mật khẩu")),
                    );
                    return;
                  }
                  if (_otpController.text.isEmpty ||
                      _otpController.text.length < 6) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Vui lòng nhập đủ 6 số OTP")),
                    );
                    return;
                  }

                  bloc.add(ToggleTwoFactorEvent(
                    email: email,
                    password: _passwordController.text,
                    otp: _otpController.text,
                  ));
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Xác nhận"),
              ),
            ],
          );
        });
      },
    );
  } // Các phương thức đã được triển khai ở trên

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SecurityBloc()..add(TakeStatusSecurityEventSendToken()),
      child: BlocConsumer<SecurityBloc, SecurityState>(
        listener: (context, state) {
          if (state is DisableTwoFactorSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Đã tắt xác thực 2 yếu tố thành công"),
                backgroundColor: Colors.green,
              ),
            );
            setState(() {
              _twoFactorEnabled = false;
              _secretKey = null;
            });

            // Đảm bảo RuntimeMemoryStorage được cập nhật
            RuntimeMemoryStorage.set('twoFactorEnabled', false);

            // Delay nhỏ trước khi trả về kết quả để đảm bảo state đã cập nhật
            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted && Navigator.canPop(context)) {
                Navigator.pop(context, false); // Trả về trạng thái 2FA đã tắt
              }
            });
          } else if (state is EnableTwoFactorSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Đã bật xác thực 2 yếu tố thành công"),
                backgroundColor: Colors.green,
              ),
            );
            setState(() {
              _twoFactorEnabled = true;
            });

            // Đảm bảo RuntimeMemoryStorage được cập nhật
            RuntimeMemoryStorage.set('twoFactorEnabled', true);

            // Delay nhỏ trước khi trả về kết quả để đảm bảo state đã cập nhật
            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted && Navigator.canPop(context)) {
                Navigator.pop(context, true); // Trả về trạng thái 2FA đã bật
              }
            });
          } else if (state is EnableTwoFactor) {
            setState(() {
              _secretKey = state.secret;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Đã lấy mã bí mật thành công"),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is SecurityIsLoadingFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Lỗi: ${state.message}"),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is SecurityIsLoaded) {
            setState(() {
              _twoFactorEnabled = state.twoFactorEnabled;
            });
          }
        },
        builder: (context, state) {
          // Use the local state for UI rendering
          bool currentValue = _twoFactorEnabled;
          // If loading from the API, use the latest state
          if (state is SecurityIsLoaded) {
            currentValue = state.twoFactorEnabled;
          }
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                title: const Text("Xác thực 2 yếu tố"),
                foregroundColor: Theme.of(context).colorScheme.onBackground,
                elevation: 0,
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Thông tin về xác thực 2 yếu tố
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: Colors.blue.withOpacity(0.3)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.shield, color: Colors.blue),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Xác thực 2 yếu tố",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Bảo vệ tài khoản bằng mật khẩu và mã OTP 6 số được tạo từ ứng dụng xác thực.",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Card cài đặt
                      SettingsCard(
                        widgets: [
                          SettingsSwitches(
                            title: 'Xác thực 2 yếu tố',
                            description: currentValue ? 'Đang bật' : 'Đang tắt',
                            onChanged: (value) {
                              if (value != currentValue) {
                                _showToggle2FADialog(
                                    context, context.read<SecurityBloc>());
                              }
                            },
                            currentValue: currentValue,
                          ),
                        ],
                      ),

                      // Loading indicator
                      if (state is SecutiryIsLoading)
                        const Padding(
                          padding: EdgeInsets.only(top: 24.0),
                          child: Center(child: CircularProgressIndicator()),
                        ),

                      // Nút lấy mã bí mật nếu chưa bật 2FA
                      if (!currentValue) ...[
                        const SizedBox(height: 24),
                        Text(
                          "Cách bật xác thực 2 yếu tố:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border:
                                Border.all(color: Colors.grey.withOpacity(0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("1.",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      child: Text("Lấy mã bí mật từ hệ thống")),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("2.",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      child: Text(
                                          "Quét mã hoặc nhập mã vào ứng dụng xác thực")),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("3.",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      child: Text(
                                          "Nhập mã OTP được tạo để hoàn tất kích hoạt")),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              context
                                  .read<SecurityBloc>()
                                  .add(EnableTwoFactorEvent());
                            },
                            icon: const Icon(Icons.security),
                            label: const Text("Lấy mã bí mật"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                            ),
                          ),
                        ),
                      ],

                      // Hiển thị mã bí mật nếu đã lấy
                      if (_secretKey != null && !currentValue) ...[
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Colors.green.withOpacity(0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.check_circle, color: Colors.green),
                                  SizedBox(width: 8),
                                  Text(
                                    "Mã bí mật của bạn",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "Vui lòng nhập mã bí mật này vào ứng dụng xác thực:",
                                style: TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: SelectableText(
                                        _secretKey ?? "",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'monospace',
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.copy),
                                      tooltip: "Sao chép mã",
                                      onPressed: () {
                                        Clipboard.setData(ClipboardData(
                                            text: _secretKey ?? ""));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  "Đã sao chép mã bí mật")),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              // Nút mở ứng dụng xác thực
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Platform.isAndroid
                                      ? ElevatedButton.icon(
                                          onPressed: _openGoogleAuthenticator,
                                          icon: const Icon(Icons.open_in_new),
                                          label: const Text(
                                              "Mở Google Authenticator"),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                            foregroundColor: Colors.white,
                                          ),
                                        )
                                      : ElevatedButton.icon(
                                          onPressed: _showAuthenticatorOptions,
                                          icon: const Icon(Icons.apps),
                                          label: const Text(
                                              "Chọn ứng dụng xác thực"),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                            foregroundColor: Colors.white,
                                          ),
                                        ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                "Nhập mã OTP được tạo để hoàn tất việc kích hoạt.",
                                style: TextStyle(
                                    fontSize: 14, fontStyle: FontStyle.italic),
                              ),
                              const SizedBox(height: 16),
                              Center(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    _showToggle2FADialog(
                                        context, context.read<SecurityBloc>());
                                  },
                                  icon: const Icon(Icons.check),
                                  label: const Text("Tiếp tục kích hoạt"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ));
        },
      ),
    );
  }
}
