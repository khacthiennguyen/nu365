import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nu365/core/data/local/data_local.dart';
import 'package:nu365/core/data/local/data_security.dart';
import 'package:nu365/core/data/runtime/runtime_memory_storage.dart';
import 'package:nu365/core/states/authenticate/authenticate_bloc.dart';
import 'package:nu365/core/states/authenticate/authenticate_event.dart';
import 'package:nu365/features/security/utils/auth_local.dart';

class BiometricAuthHelper {
  static final DataSecurity _dataSecurity = DataSecurity();
  
  // Số lần thử tối đa trước khi đăng xuất
  static const int MAX_ATTEMPTS = 3;
  
  // Lưu số lần thử xác thực thất bại
  static int _failedAttempts = 0;
  
  // Đặt lại số lần thử thất bại
  static void resetFailedAttempts() {
    _failedAttempts = 0;
  }
  
  // Tăng số lần thử thất bại và kiểm tra có vượt quá giới hạn không
  static bool incrementFailedAttempts() {
    _failedAttempts++;
    return _failedAttempts >= MAX_ATTEMPTS;
  }
  /// Kiểm tra xem người dùng có cần xác thực sinh trắc học không
  static Future<bool> shouldRequireBiometricAuth(String userId) async {
    try {
      print("DEBUG: Kiểm tra yêu cầu xác thực sinh trắc học cho userId: $userId");
      // Kiểm tra xem thiết bị có hỗ trợ sinh trắc học không
      final canUseBiometrics = await AuthLocal.canUseBiometrics();
      print("DEBUG: Thiết bị hỗ trợ sinh trắc học: $canUseBiometrics");
      
      if (!canUseBiometrics) {
        print("DEBUG: Thiết bị không hỗ trợ sinh trắc học, bỏ qua xác thực");
        return false;
      }

      // Kiểm tra xem người dùng có bật sinh trắc học không
      final isBiometricEnabled = await _dataSecurity.getBiometricStatus();
      print("DEBUG: Trạng thái sinh trắc học trong cài đặt: $isBiometricEnabled");
      
      if (!isBiometricEnabled) {
        print("DEBUG: Người dùng chưa bật sinh trắc học, bỏ qua xác thực");
        return false;
      }

      // Kiểm tra xem ID người dùng có khớp không
      final storedUserId = await _dataSecurity.getBiometricUserId();
      print("DEBUG: ID người dùng đã lưu: $storedUserId, ID hiện tại: $userId");
      
      final shouldRequire = storedUserId == userId;
      print("DEBUG: Yêu cầu xác thực sinh trắc học: $shouldRequire");
      
      return shouldRequire;
    } catch (e) {
      print("DEBUG: Lỗi khi kiểm tra yêu cầu xác thực sinh trắc học: $e");
      // Nếu có lỗi, trả về false để không yêu cầu xác thực sinh trắc học
      return false;
    }
  }/// Xác thực sinh trắc học khi khởi động ứng dụng
  /// Trả về true nếu xác thực thành công hoặc không cần xác thực
  static Future<bool> authenticateOnStartup(
      BuildContext context, String userId, String accessToken) async {
    print("DEBUG: Bắt đầu xác thực sinh trắc học cho userId: $userId");
    
    // Kiểm tra xem có cần xác thực sinh trắc học không
    final requireBiometric = await shouldRequireBiometricAuth(userId);
    print("DEBUG: Yêu cầu xác thực sinh trắc học: $requireBiometric");

    if (!requireBiometric) {
      print("DEBUG: Không cần xác thực sinh trắc học, đăng nhập trực tiếp");
      // Nếu không cần xác thực sinh trắc học, đăng nhập trực tiếp
      if (context.mounted) {
        context.read<AuthenticateBloc>().add(AuthenticateLoggedIn(accessToken));
        print("DEBUG: Đã phát sự kiện đăng nhập");
      } else {
        print("DEBUG: Context không còn valid, không thể phát sự kiện đăng nhập");
      }
      return true;
    }

    print("DEBUG: Thực hiện xác thực sinh trắc học...");
    // Thực hiện xác thực sinh trắc học
    final authenticated = await AuthLocal.authenticate();
    print("DEBUG: Kết quả xác thực sinh trắc học: $authenticated");

    if (authenticated) {
      print("DEBUG: Xác thực thành công, đặt lại số lần thử và đăng nhập");
      // Nếu xác thực thành công, đặt lại số lần thử thất bại và đăng nhập
      resetFailedAttempts();
      if (context.mounted) {
        context.read<AuthenticateBloc>().add(AuthenticateLoggedIn(accessToken));
        print("DEBUG: Đã phát sự kiện đăng nhập sau xác thực sinh trắc học thành công");
      } else {
        print("DEBUG: Context không còn valid sau xác thực thành công");
      }
      return true;
    } else {
      print("DEBUG: Xác thực thất bại, tăng số lần thử thất bại");
      // Xác thực thất bại, tăng số lần thử thất bại
      final maxAttemptsReached = incrementFailedAttempts();
      print("DEBUG: Số lần thử hiện tại: $_failedAttempts, Đã đạt giới hạn: $maxAttemptsReached");
      
      if (maxAttemptsReached) {
        print("DEBUG: Đã đạt đến số lần thử tối đa, bắt đầu xử lý đăng xuất");
        // Nếu đã đạt đến số lần thử tối đa, đăng xuất và chuyển về màn hình đăng nhập
        if (context.mounted) {
          await _handleMaxAttemptsReached(context);
          print("DEBUG: Đã hoàn thành xử lý đăng xuất sau khi đạt số lần thử tối đa");
        } else {
          print("DEBUG: Context không còn valid, không thể xử lý đăng xuất");
        }
        return false;
      }
      
      print("DEBUG: Xác thực thất bại, nhưng chưa đạt số lần thử tối đa");
      // Xác thực thất bại, không đăng nhập
      return false;
    }
  }
  /// Xử lý khi đạt đến số lần thử tối đa
  static Future<void> _handleMaxAttemptsReached(BuildContext context) async {
    try {
      print("DEBUG: Đã đạt đến số lần thử tối đa. Đăng xuất người dùng...");
      
      // Đặt lại số lần thử ngay lập tức
      resetFailedAttempts();
      print("DEBUG: Đã đặt lại số lần thử thất bại về 0");
      
      if (!context.mounted) {
        print("DEBUG: Context không còn valid, không thể hiển thị thông báo");
        return;
      }
      
      // Hiển thị thông báo cho người dùng
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Quá nhiều lần thử không thành công. Vui lòng đăng nhập lại.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      print("DEBUG: Đã hiển thị thông báo lỗi cho người dùng");
      
      // Xóa session trong SQLite
      await SQLite.deleteSession();
      print("DEBUG: Đã xóa session từ SQLite");
      
      // Xóa dữ liệu trong bộ nhớ
      RuntimeMemoryStorage.clear();
      print("DEBUG: Đã xóa dữ liệu từ bộ nhớ");
      
      if (!context.mounted) {
        print("DEBUG: Context không còn valid sau khi xóa dữ liệu");
        return;
      }
      
      // Phát sự kiện đăng xuất trước
      context.read<AuthenticateBloc>().add(AuthenticateLoggedOut());
      print("DEBUG: Đã phát sự kiện đăng xuất");
      
      // Chờ một chút để đảm bảo bloc cập nhật trạng thái
      await Future.delayed(const Duration(seconds: 2));
      
      // Kiểm tra context lần cuối và chuyển về màn hình đăng nhập
      if (context.mounted) {
        print("DEBUG: Đang chuyển đến màn hình đăng nhập");
        context.go('/sign-in');
      } else {
        print("DEBUG: Context không còn valid sau khi đợi, không thể chuyển trang");
      }
    } catch (e) {
      print("DEBUG: Lỗi khi xử lý số lần thử tối đa: $e");
    }
  }

  /// Cập nhật trạng thái biometric khi đăng ký hoặc vô hiệu hóa
  static Future<void> updateBiometricStatus(bool enabled, String userId) async {
    await _dataSecurity.writeBiometricStatus(enabled);

    if (enabled) {
      await _dataSecurity.writeBiometricUserId(userId);
    } else {
      await _dataSecurity.clearBiometricData();
    }
  }
}
