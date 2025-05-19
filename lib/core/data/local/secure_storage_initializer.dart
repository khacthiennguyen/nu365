import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageInitializer {
  static final SecureStorageInitializer _instance = SecureStorageInitializer._internal();
  static FlutterSecureStorage? _secureStorage;

  factory SecureStorageInitializer() {
    return _instance;
  }

  SecureStorageInitializer._internal();

  static Future<void> initialize() async {
    try {
      // Khởi tạo FlutterSecureStorage với cấu hình mặc định
      _secureStorage = const FlutterSecureStorage();
      
      // Thử đọc một giá trị đơn giản để kiểm tra xem plugin có hoạt động không
      await _secureStorage!.read(key: 'init_test');
      print("DEBUG: FlutterSecureStorage đã được khởi tạo thành công");
    } catch (e) {
      print("DEBUG: Lỗi khi khởi tạo FlutterSecureStorage: $e");
      // Nếu có lỗi, vẫn tạo một instance để tránh null
      _secureStorage = const FlutterSecureStorage();
    }
  }

  static FlutterSecureStorage get instance {
    if (_secureStorage == null) {
      _secureStorage = const FlutterSecureStorage();
    }
    return _secureStorage!;
  }
}
