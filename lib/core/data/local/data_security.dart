import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nu365/core/data/local/secure_storage_initializer.dart';

class DataSecurity {
  static final DataSecurity _instance = DataSecurity._internal();

  // Sử dụng SecureStorageInitializer để lấy instance đã được khởi tạo
  FlutterSecureStorage get secureStorage => SecureStorageInitializer.instance;

  factory DataSecurity() {
    return _instance;
  }

  DataSecurity._internal();

  // Lưu trạng thái biometric
  Future<void> writeBiometricStatus(bool status) async {
    try {
      await secureStorage.write(
          key: 'biometric_status', value: status.toString());
    } catch (e) {
      print("DEBUG: Lỗi khi ghi trạng thái biometric: $e");
    }
  }

  // Lấy trạng thái biometric
  Future<bool> getBiometricStatus() async {
    try {
      final status = await secureStorage.read(key: 'biometric_status');
      return status?.toLowerCase() == 'true';
    } catch (e) {
      print("DEBUG: Lỗi khi đọc trạng thái biometric: $e");
      return false;
    }
  }

  // Lưu user ID kết hợp với biometric
  Future<void> writeBiometricUserId(String userId) async {
    try {
      await secureStorage.write(key: 'biometric_user_id', value: userId);
    } catch (e) {
      print("DEBUG: Lỗi khi ghi user ID biometric: $e");
    }
  }

  // Lấy user ID đã đăng ký biometric
  Future<String?> getBiometricUserId() async {
    try {
      return await secureStorage.read(key: 'biometric_user_id');
    } catch (e) {
      print("DEBUG: Lỗi khi đọc user ID biometric: $e");
      return null;
    }
  }

  // Xóa dữ liệu biometric khi đăng xuất
  Future<void> clearBiometricData() async {
    try {
      await secureStorage.delete(key: 'biometric_status');
      await secureStorage.delete(key: 'biometric_user_id');
    } catch (e) {
      print("DEBUG: Lỗi khi xóa dữ liệu biometric: $e");
    }
  }
}
