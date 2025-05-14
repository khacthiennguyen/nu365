import 'package:dio/dio.dart';
import 'package:nu365/core/api/dio/dio.dart';
import 'package:nu365/core/api/utils/base_response.dart';
import 'package:nu365/core/data/runtime/runtime_memory_storage.dart';
import 'package:nu365/features/security/logic/security_state.dart';
import 'package:nu365/features/security/utils/security_error_messages.dart';

class SercurityServices {
  static Future<SecurityState> getSecurityStatus() async {
    try {
      BaseResponse response =
          BaseResponse.fromDIOResponse(await dio.get("auth/security"));
      if (response.httpStatus == 200) {
        if (response.payload == null) {
          return SecurityIsLoadingFailure(
              message: "Phản hồi từ máy chủ không hợp lệ");
        }
        try {
          final bool twoFactorEnabled =
              response.payload['twoFactorEnabled'] ?? false;
          RuntimeMemoryStorage.set('twoFactorEnabled', twoFactorEnabled);
          final bool biometricEnabled =
              response.payload['biometricEnabled'] ?? false;
          RuntimeMemoryStorage.set('biometricEnabled', biometricEnabled);

          return SecurityIsLoaded(
              biometricEnabled: biometricEnabled,
              twoFactorEnabled: twoFactorEnabled);
        } catch (e) {
          return SecurityIsLoadingFailure(
              message: "Không thể xử lý thông tin bảo mật: ${e.toString()}");
        }
      }

      // Xử lý lỗi dựa trên HTTP status code
      if (response.httpStatus == 401) {
        return SecurityIsLoadingFailure(
            message: SecurityErrorMessages.invalidCredentials);
      } else if (response.httpStatus >= 500) {
        return SecurityIsLoadingFailure(
            message: SecurityErrorMessages.serverError);
      }

      return SecurityIsLoadingFailure(
          message:
              response.message != null && response.message.toString().isNotEmpty
                  ? response.message.toString()
                  : "Lỗi từ máy chủ: ${response.httpStatus}");
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return SecurityIsLoadingFailure(
            message: SecurityErrorMessages.networkError);
      }
      return SecurityIsLoadingFailure(message: "Lỗi kết nối: ${e.message}");
    } catch (e) {
      return SecurityIsLoadingFailure(
          message: "Lỗi không xác định: ${e.toString()}");
    }
  }

  static Future<SecurityState> enable2fa() async {
    try {
      BaseResponse response =
          BaseResponse.fromDIOResponse(await dio.post("auth/enable-2fa"));

      if (response.httpStatus == 200) {
        if (response.payload == null) {
          return SecurityIsLoadingFailure(
              message: "Phản hồi từ máy chủ không hợp lệ");
        }
        try {
          final String secret = response.payload['secret'];
          return EnableTwoFactor(secret: secret);
        } catch (e) {
          return SecurityIsLoadingFailure(
              message: "Không thể xử lý phản hồi từ máy chủ: ${e.toString()}");
        }
      }

      // Xử lý các mã lỗi cụ thể
      if (response.code > 0) {
        if (response.code == 5012) {
          return SecurityIsLoadingFailure(
              message: SecurityErrorMessages.enableTwoFAFailed);
        }
      }

      // Xử lý lỗi dựa trên HTTP status code
      if (response.httpStatus == 401) {
        return SecurityIsLoadingFailure(
            message: SecurityErrorMessages.invalidCredentials);
      } else if (response.httpStatus >= 500) {
        return SecurityIsLoadingFailure(
            message: SecurityErrorMessages.serverError);
      }

      return SecurityIsLoadingFailure(
          message:
              response.message != null && response.message.toString().isNotEmpty
                  ? response.message.toString()
                  : "Lỗi từ máy chủ: ${response.httpStatus}");
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return SecurityIsLoadingFailure(
            message: SecurityErrorMessages.networkError);
      }
      return SecurityIsLoadingFailure(message: "Lỗi kết nối: ${e.message}");
    } catch (e) {
      return SecurityIsLoadingFailure(
          message: "Lỗi không xác định: ${e.toString()}");
    }
  }

  static Future<SecurityState> toggleTwoFactor({
    required String email,
    required String password,
    required String otp,
  }) async {
    bool is2FAEnabled = RuntimeMemoryStorage.get('twoFactorEnabled') ?? false;
    String endpoint = is2FAEnabled ? "auth/disable-2fa" : "auth/verify-otp";

    try {
      BaseResponse response = BaseResponse.fromDIOResponse(
        await dio.post(endpoint, data: {
          "email": email,
          "password": password,
          "otp": otp,
        }),
      );
      if (response.httpStatus == 200) {
        // Cập nhật trạng thái 2FA sau khi gọi API thành công
        bool newValue = !is2FAEnabled;
        RuntimeMemoryStorage.set('twoFactorEnabled', newValue);

        // Gọi lại API để cập nhật trạng thái mới nhất
        await getSecurityStatus();

        return is2FAEnabled
            ? DisableTwoFactorSuccess()
            : EnableTwoFactorSuccess();
      }

      // Xử lý lỗi theo mã lỗi cụ thể
      if (response.code > 0) {
        // Sử dụng class tiện ích để lấy thông báo lỗi dựa trên mã lỗi
        String errorMessage = SecurityErrorMessages.getMessageForErrorCode(
            response.code, is2FAEnabled);
        return SecurityIsLoadingFailure(message: errorMessage);
      }

      // Xử lý cụ thể cho lỗi xác thực (HTTP 401)
      if (response.httpStatus == 401) {
        String errorMessage = SecurityErrorMessages.invalidCredentials;

        // Xác định lỗi cụ thể từ message trả về (nếu có)
        if (response.message != null) {
          String messageStr = response.message.toString().toLowerCase();
          if (messageStr.contains("password")) {
            errorMessage = SecurityErrorMessages.invalidPassword;
          } else if (messageStr.contains("otp")) {
            errorMessage = SecurityErrorMessages.invalidOTP;
          }
        }

        return SecurityIsLoadingFailure(message: errorMessage);
      }

      // Xử lý HTTP 400 (Bad Request) cho các lỗi khác
      if (response.httpStatus == 400) {
        return SecurityIsLoadingFailure(
          message:
              response.message != null && response.message.toString().isNotEmpty
                  ? response.message.toString()
                  : "Dữ liệu không hợp lệ, vui lòng kiểm tra lại thông tin",
        );
      }

      // Xử lý HTTP 500 (Internal Server Error)
      if (response.httpStatus >= 500) {
        return SecurityIsLoadingFailure(
          message: SecurityErrorMessages.serverError,
        );
      }

      // Xử lý các lỗi khác
      return SecurityIsLoadingFailure(
        message:
            response.message != null && response.message.toString().isNotEmpty
                ? response.message.toString()
                : "Lỗi từ server: ${response.httpStatus}",
      );
    } on DioException catch (e) {
      // Xử lý lỗi DioException
      if (e.response?.statusCode == 401) {
        return SecurityIsLoadingFailure(
            message: SecurityErrorMessages.invalidCredentials);
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return SecurityIsLoadingFailure(
            message: SecurityErrorMessages.networkError);
      }
      return SecurityIsLoadingFailure(message: "Lỗi kết nối: ${e.message}");
    } catch (e) {
      return SecurityIsLoadingFailure(
          message: "Lỗi không xác định: ${e.toString()}");
    }
  }
}
