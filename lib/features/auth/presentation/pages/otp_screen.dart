import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nu365/core/constants/app_theme.dart';
import 'package:nu365/core/states/authenticate/authenticate_bloc.dart';
import 'package:nu365/features/auth/logic/login_bloc.dart';
import 'package:nu365/features/auth/logic/login_event.dart';
import 'package:otp_pin_field/otp_pin_field.dart';

class OtpScreen extends StatefulWidget {
  final String email;
  final String password;

  const OtpScreen({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpPinFieldController = GlobalKey<OtpPinFieldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xác thực OTP'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text('Nhập mã xác thực trong ứng dụng Authenticator ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                ),
                const SizedBox(height: 32),
                OtpPinField(
                  key: _otpPinFieldController,
                  autoFillEnable: true,
                  otpPinFieldStyle: const OtpPinFieldStyle(
                    defaultFieldBorderColor: Colors.grey,
                    activeFieldBorderColor: Colors.deepPurple,
                    fieldBorderRadius: 12.0,
                    // fieldBorderWidth: 60,
                    // fieldWidth: 50,
                    textStyle: TextStyle(fontSize: 16),
                  ),
                  maxLength: 6,
                  onSubmit: (String otp) {
                    context.read<LoginBloc>().add(
                          LoginWithOtpEvent(
                            email: widget.email,
                            password: widget.password,
                            otp: otp,
                          ),
                        );
                  },
                  showCursor: true,
                  onChange: (String text) {},
                ),
                const SizedBox(height: 32),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      final otpText =
                          _otpPinFieldController.currentState?.controller.text;

                      // Kiểm tra xem đã nhập đủ 6 số OTP chưa
                      if (otpText == null || otpText.length < 6) {
                        // Hiển thị cảnh báo nếu chưa nhập đủ
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Vui lòng nhập đủ 6 số mã xác thực'),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        return;
                      }

                      // Nếu đã nhập đủ, tiến hành xác thực
                      context.read<LoginBloc>().add(
                            LoginWithOtpEvent(
                              email: widget.email,
                              password: widget.password,
                              otp: otpText,
                            ),
                          );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 48, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Xác nhận',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
