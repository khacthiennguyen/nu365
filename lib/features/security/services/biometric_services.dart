import 'package:dio/dio.dart';
import 'package:nu365/core/api/dio/dio.dart';
import 'package:nu365/core/api/utils/base_response.dart';
import 'package:nu365/core/data/local/data_security.dart';
import 'package:nu365/core/data/runtime/runtime_memory_storage.dart';
import 'package:nu365/features/security/logic/biometric_state.dart';
import 'package:nu365/features/security/utils/auth_local.dart';
import 'package:nu365/features/security/utils/device_info.dart';
import 'package:nu365/features/security/utils/security_error_messages.dart';

class BiometricServices {
  /// Kích hoạt xác thực sinh trắc học
  static Future<BiometricState> registerBiometric() async {
    try {
      // Kiểm tra và yêu cầu xác thực sinh trắc học TRƯỚC KHI gọi API
      if (await AuthLocal.canUseBiometrics()) {
        print("Bắt đầu xác thực sinh trắc học");
        bool authenticated = await AuthLocal.authenticate();
        if (!authenticated) {
          return BiometricStateFailure(
            message: "Xác thực sinh trắc học không thành công",
          );
        }
        // Nếu xác thực thành công, tiếp tục quy trình
        print("Xác thực sinh trắc học thành công");
      } else {
        return BiometricStateFailure(
          message: "Thiết bị không hỗ trợ xác thực sinh trắc học",
        );
      }

      // Lấy thiết bị ID để đăng ký với máy chủ
      final String? deviceId = await DeviceInfoService.getDeviceId();
      final String? deviceModel = await DeviceInfoService.getDeviceModel();
      final String? devicePlatform = await DeviceInfoService.getPlatformName();

      // Kiểm tra tất cả các thông tin bắt buộc có sẵn
      if (deviceId == null || deviceId.isEmpty) {
        return BiometricStateFailure(
          message: "Không thể lấy thông tin thiết bị",
        );
      }

      // Thực hiện cập nhật trạng thái lên máy chủ sau khi đã xác thực thành công
      final response = await dio.post(
        'biometric/enable',
        data: {
          'deviceId': deviceId,
          'deviceModel': deviceModel,
          'devicePlatform': devicePlatform,
        },
      );

      final baseResponse = BaseResponse.fromDIOResponse(response);

      if (baseResponse.httpStatus == 200) {
        print("Biometric enabled api called successfully");
        // Xác thực đã thành công và API đã thành công - cập nhật trạng thái trong bộ nhớ
        RuntimeMemoryStorage.set('biometricEnabled', true);

        // Lưu trạng thái vào secure storage
        final userId = RuntimeMemoryStorage.getSession()?['uId'];
        if (userId != null) {
          await DataSecurity().writeBiometricStatus(true);
          await DataSecurity().writeBiometricUserId(userId);
        }

        return BiometricActivated();
      } else {
        // Xử lý lỗi dựa trên HTTP status code
        if (baseResponse.httpStatus == 401) {
          return BiometricStateFailure(
            message: SecurityErrorMessages.invalidCredentials,
          );
        } else if (baseResponse.httpStatus >= 500) {
          return BiometricStateFailure(
            message: SecurityErrorMessages.serverError,
          );
        }

        return BiometricStateFailure(
          message: baseResponse.message != null &&
                  baseResponse.message.toString().isNotEmpty
              ? baseResponse.message.toString()
              : "Lỗi từ máy chủ: ${baseResponse.httpStatus}",
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        return BiometricStateFailure(
          message:
              "Yêu cầu không hợp lệ: ${e.response?.data['message'] ?? 'Lỗi định dạng yêu cầu'}",
        );
      }
      return BiometricStateFailure(
        message: "Không thể kết nối đến máy chủ: ${e.message}",
      );
    } catch (e) {
      return BiometricStateFailure(
        message: "Lỗi không xác định: $e",
      );
    }
  }

  static Future<BiometricState> disableBiometric() async {
    try {
      // Lấy thiết bị ID để đăng ký với máy chủ
      final String? deviceId = await DeviceInfoService.getDeviceId();

      // Kiểm tra thông tin thiết bị
      if (deviceId == null || deviceId.isEmpty) {
        return BiometricStateFailure(
          message: "Không thể lấy thông tin thiết bị",
        );
      }

      // Thực hiện cập nhật trạng thái lên máy chủ
      final response = await dio.post(
        'biometric/disable',
        data: {
          'deviceId': deviceId,
        },
      );

      final baseResponse = BaseResponse.fromDIOResponse(response);

      if (baseResponse.httpStatus == 200) {
        print("Biometric disabled api called successfully");
        // Cập nhật trạng thái trong bộ nhớ
        RuntimeMemoryStorage.set('biometricEnabled', false);

        // Cập nhật trong secure storage
        await DataSecurity().writeBiometricStatus(false);
        await DataSecurity().clearBiometricData();

        return BiometricDeactive();
      } else {
        // Xử lý lỗi dựa trên HTTP status code
        if (baseResponse.httpStatus == 401) {
          return BiometricStateFailure(
            message: SecurityErrorMessages.invalidCredentials,
          );
        } else if (baseResponse.httpStatus >= 500) {
          return BiometricStateFailure(
            message: SecurityErrorMessages.serverError,
          );
        }

        return BiometricStateFailure(
          message: baseResponse.message != null &&
                  baseResponse.message.toString().isNotEmpty
              ? baseResponse.message.toString()
              : "Lỗi từ máy chủ: ${baseResponse.httpStatus}",
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        return BiometricStateFailure(
          message:
              "Yêu cầu không hợp lệ: ${e.response?.data['message'] ?? 'Lỗi định dạng yêu cầu'}",
        );
      }
      return BiometricStateFailure(
        message: "Không thể kết nối đến máy chủ: ${e.message}",
      );
    } catch (e) {
      return BiometricStateFailure(
        message: "Lỗi không xác định: $e",
      );
    }
  }
}
