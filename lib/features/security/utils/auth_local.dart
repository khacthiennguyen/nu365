import 'package:flutter/services.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';

class AuthLocal {
  static final LocalAuthentication _localAuth = LocalAuthentication();

  /// Kiểm tra khả năng sinh trắc học trên thiết bị
  static Future<bool> canUseBiometrics() async {
    try {
      // Kiểm tra xem thiết bị có hỗ trợ xác thực sinh trắc học không
      final canAuthenticateWithBiometrics = await _localAuth.canCheckBiometrics;
      final canAuthenticate = await _localAuth.isDeviceSupported();

      return canAuthenticateWithBiometrics && canAuthenticate;
    } on PlatformException catch (e) {
      print('Error checking biometric support: $e');
      return false;
    }
  }

  /// Lấy danh sách các loại sinh trắc học có sẵn trên thiết bị
  static Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print('Error getting available biometrics: $e');
      return [];
    }
  }

  /// Xác thực người dùng bằng sinh trắc học
  static Future<bool> authenticate() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'Xác thực để truy cập ứng dụng',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        print('Biometric authentication not available');
      } else if (e.code == auth_error.notEnrolled) {
        print('No biometric enrolled on this device');
      } else if (e.code == 'no_fragment_activity') {
        print('Lỗi cấu hình: Activity phải là FragmentActivity');
        // Trong trường hợp này, MainActivity đã được sửa, nhưng vẫn gặp lỗi
        // Có thể cần chạy lại với flutter clean hoặc khởi động lại ứng dụng
      } else {
        print('Biometric authentication error: $e');
      }
      return false;
    }
  }
}
