import 'dart:io';

import 'package:dio/dio.dart';
import 'package:nu365/core/api/dio/dio.dart' show dio;
import 'package:nu365/core/api/utils/base_response.dart';
import 'package:nu365/core/data/local/data_local.dart';
import 'package:nu365/core/data/local/data_security.dart';
import 'package:nu365/core/data/runtime/runtime_memory_storage.dart';
import 'package:nu365/features/auth/logic/login_state.dart';
import 'package:nu365/features/auth/logic/register_state.dart';
import 'package:nu365/features/auth/models/credentail.dart';

class AuthenticateService {
  // Kiểm tra và khôi phục trạng thái biometric nếu có
  static Future<void> _restoreBiometricStatusIfNeeded(String userId) async {
    try {
      final DataSecurity dataSecurity = DataSecurity();
      final bool biometricStatus = await dataSecurity.getBiometricStatus();
      final String? storedUserId = await dataSecurity.getBiometricUserId();

      // Nếu có trạng thái biometric và userId khớp, thì cập nhật lại RuntimeMemoryStorage
      if (biometricStatus && storedUserId == userId) {
        RuntimeMemoryStorage.set('biometricEnabled', true);
      }
    } catch (e) {
      print('Error restoring biometric status: $e');
    }
  }

  static Future<LoginState> login(String email, String password) async {
    try {
      BaseResponse response = BaseResponse.fromDIOResponse(await dio
          .post("auth/login", data: {"email": email, "password": password}));

      if (response.httpStatus == 200) {
        if (response.payload == null) {
          return LoginFailed(message: "Invalid response from server");
        }
        try {
          Credential credential = Credential.fromJson(response.payload);
          // print(credential.toJson().toString());
          String uId = credential.user.id;
          String username = credential.user.name;
          String email = credential.user.email;
          String accessToken = credential.session.accessToken;
          // Convert Unix timestamp (seconds) to DateTime and then to ISO string format
          DateTime expiredDateTime = DateTime.fromMillisecondsSinceEpoch(
              credential.session.expiresAt *
                  1000); // Convert seconds to milliseconds
          String expiredAt = expiredDateTime
              .toIso8601String(); // print("full ifo: $uId, $username, $accessToken, $expiredAt");
          print("DEBUG: Saving session after successful login");
          try {
            await SQLite.saveSession(
                uId: uId,
                username: username,
                email: email,
                accessToken: accessToken,
                expiredAt: expiredAt);
            print("DEBUG: Session saved to SQLite successfully");
          } catch (dbError) {
            print("DEBUG: Error saving session to SQLite: $dbError");
            // Continue even if SQLite save fails, as we still have in-memory session
          }

          // Save user information to local storage
          RuntimeMemoryStorage.setSession(
              uId: uId,
              username: username,
              email: email,
              accessToken: accessToken,
              expiredAt: expiredAt);
          print("DEBUG: Session saved to RuntimeMemoryStorage");

          // Khôi phục trạng thái biometric nếu có
          await _restoreBiometricStatusIfNeeded(uId);

          return LoginSuccess(
              credential: credential); // Return the credential object);
        } catch (e) {
          return LoginFailed(message: "Failed to parse credentials");
        }
      }

      if (response.httpStatus == 403) {
        return Login2FARequired(
            email: email, password: password); // 2FA required
      }

      return LoginFailed(message: "Unexpected response from server");
    } on DioException catch (error) {
      if (error.response == null) {
        return LoginFailed(
            error: error,
            message: "Network error: Unable to connect to server");
      }

      BaseResponse response = BaseResponse.fromDIOResponse(error.response!);
      // ===== Xử lý các trường hợp xác thực đặc biệt =====

      // Trường hợp 1: Yêu cầu xác thực 2FA với HTTP 403
      if (response.httpStatus == 403 &&
          response.message != null &&
          response.message!.contains("2FA is enabled")) {
        return Login2FARequired(email: email, password: password);
      }

      // Trường hợp 2: Quá nhiều yêu cầu đăng nhập
      if (response.isMatch(HttpStatus.tooManyRequests)) {
        return LoginToManyRequest();
      }

      // Trường hợp 3: Tài khoản cần kích hoạt
      if (response.isMatch(HttpStatus.unauthorized, HttpStatus.continue_)) {
        return LoginActiveRequired(email: email, password: password);
      }

      // Trường hợp 4: Tài khoản không tồn tại
      if (response.isMatch(HttpStatus.unauthorized, HttpStatus.notFound)) {
        return LoginFailed(message: "Account not exists!");
      }

      // Trường hợp mặc định: Đăng nhập thất bại với thông báo từ server
      return LoginFailed(
          error: error,
          message: response.message ?? "Incorrect email or password!");
    } catch (error) {
      return LoginFailed(error: error as Exception, message: error.toString());
    }
  }

//đăng ký tài khoản
  static Future<RegisterState> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      BaseResponse response =
          BaseResponse.fromDIOResponse(await dio.post("auth/register", data: {
        "name": name,
        "email": email,
        "password": password,
      }));

      // For registration success - HTTP 200, 201
      if (response.httpStatus == 200 || response.httpStatus == 201) {
        return RegisterSuccess();
      }

      // If we need to verify email before activating account
      if (response.httpStatus == 202) {
        return RegisterActivationRequired(email: email, name: name);
      }

      return RegisterFailed(message: response.message ?? "Registration failed");
    } on DioException catch (error) {
      if (error.response == null) {
        return RegisterFailed(
            error: error,
            message: "Network error: Unable to connect to server");
      }

      BaseResponse response = BaseResponse.fromDIOResponse(error.response!);

      if (response.isMatch(HttpStatus.tooManyRequests)) {
        return RegisterToManyRequest();
      }

      if (response.isMatch(HttpStatus.conflict)) {
        return RegisterFailed(message: "Email already exists");
      }

      return RegisterFailed(
          error: error, message: response.message ?? "Registration failed");
    } catch (error) {
      return RegisterFailed(
          error: error as Exception, message: error.toString());
    }
  }

  static Future<LoginState> loginwithotp(
    String email,
    String password,
    String otp,
  ) async {
    try {
      BaseResponse response = BaseResponse.fromDIOResponse(await dio.post(
        "auth/login-with-otp",
        data: {"email": email, "password": password, "otp": otp},
      ));

      if (response.httpStatus == 200) {
        if (response.payload == null) {
          return LoginFailed(message: "Invalid response from server");
        }
        try {
          Credential credential = Credential.fromJson(response.payload);
          //  print(credential.toJson().toString());
          String uId = credential.user.id;
          String username = credential.user.name;
          String accessToken = credential.session.accessToken;
          String email = credential.user.email;

          // Convert Unix timestamp (seconds) to DateTime and then to ISO string format
          DateTime expiredDateTime = DateTime.fromMillisecondsSinceEpoch(
              credential.session.expiresAt *
                  1000); // Convert seconds to milliseconds
          String expiredAt = expiredDateTime.toIso8601String();

          // print("full ifo: $uId, $username, $accessToken, $expiredAt");
          await SQLite.saveSession(
              uId: uId,
              username: username,
              email: email,
              accessToken: accessToken,
              expiredAt: expiredAt);
          // Save user information to local storage
          RuntimeMemoryStorage.setSession(
            uId: uId,
            username: username,
            email: email,
            accessToken: accessToken,
            expiredAt: expiredAt,
          );

          // Khôi phục trạng thái biometric nếu có
          await _restoreBiometricStatusIfNeeded(uId);

          return LoginSuccess(
              credential: credential); // Return the credential object);
        } catch (e) {
          return LoginFailed(message: "Failed to parse credentials");
        }
      }

      return LoginFailed(message: "Unexpected response from server");
    } on DioException catch (error) {
      if (error.response == null) {
        return LoginFailed(
            error: error,
            message: "Network error: Unable to connect to server");
      }

      BaseResponse response = BaseResponse.fromDIOResponse(error.response!);

      return LoginFailed(
          error: error, message: response.message ?? "Incorrect OTP!");
    } catch (error) {
      return LoginFailed(error: error as Exception, message: error.toString());
    }
  }
}
