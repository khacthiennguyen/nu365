import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nu365/features/security/logic/security_bloc.dart';
import 'package:nu365/features/security/logic/security_event.dart';
import 'package:nu365/features/security/presentation/widgets/custom_snackbar.dart';
import 'package:nu365/features/security/utils/security_error_messages.dart';

class TwoFactorAuthDialog extends StatefulWidget {
  final String email;
  final bool is2FAEnabled;
  final Function() onCancel;

  const TwoFactorAuthDialog({
    super.key,
    required this.email,
    required this.is2FAEnabled,
    required this.onCancel,
  });

  @override
  State<TwoFactorAuthDialog> createState() => _TwoFactorAuthDialogState();
}

class _TwoFactorAuthDialogState extends State<TwoFactorAuthDialog> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _otpController.dispose();
    super.dispose();
  }
  // Xác thực đầu vào
  bool _validateInputs(BuildContext context) {
    bool isValid = true;
    
    // Kiểm tra mật khẩu
    if (_passwordController.text.isEmpty) {
      CustomSnackBar.showError(
        context: context,
        message: SecurityErrorMessages.emptyPassword,
      );
      isValid = false;
      return false; // Dừng kiểm tra ngay khi có lỗi
    }
    
    // Kiểm tra OTP
    if (_otpController.text.isEmpty || _otpController.text.length < 6) {
      CustomSnackBar.showError(
        context: context,
        message: "Vui lòng nhập đủ 6 số OTP",
      );
      isValid = false;
      return false;
    }
    
    // Kiểm tra OTP chỉ chứa số
    final RegExp otpRegex = RegExp(r'^[0-9]{6}$');
    if (!otpRegex.hasMatch(_otpController.text)) {
      CustomSnackBar.showError(
        context: context,
        message: SecurityErrorMessages.invalidOTPFormat,
      );
      isValid = false;
      return false;
    }
    
    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.is2FAEnabled
          ? "Tắt xác thực 2 yếu tố"
          : "Bật xác thực 2 yếu tố"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),          // Password field with toggle visibility
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
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 16),          // OTP field with number input only and max length
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
          onPressed: widget.onCancel,
          child: const Text("Hủy"),
        ),        ElevatedButton(
          onPressed: () {
            if (_validateInputs(context)) {
              // Gửi yêu cầu đến server
              context.read<SecurityBloc>().add(ToggleTwoFactorEvent(
                email: widget.email,
                password: _passwordController.text,
                otp: _otpController.text,
              ));
              
              // Đóng dialog
              Navigator.of(context).pop();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
          ),
          child: const Text("Xác nhận"),
        ),
      ],
    );
  }
}
