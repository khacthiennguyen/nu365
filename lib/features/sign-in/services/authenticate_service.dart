import 'dart:io';

import 'package:dio/dio.dart';
import 'package:nu365/core/api/dio/dio.dart' show dio;
import 'package:nu365/core/api/utils/base_response.dart';
import 'package:nu365/core/data/local/data_local.dart';
import 'package:nu365/core/data/runtime/runtime_memory_storage.dart';
import 'package:nu365/features/sign-in/logic/login_state.dart';
import 'package:nu365/features/sign-in/models/credentail.dart';

class AuthenticateService {
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
        //  print(credential.toJson().toString());
          String uId = credential.user.id;
          String username = credential.user.name;
          String accessToken = credential.session.accessToken;
          String expiredAt = credential.session.expiresAt.toString();
          // print("full ifo: $uId, $username, $accessToken, $expiredAt");
          await SQLite.saveSession(
              uId: uId,
              username: username,
              accessToken: accessToken,
              expiredAt: expiredAt);
          // Save user information to local storage
        RuntimeMemoryStorage.setSession (
            uId: uId, 
            username: username, 
            accessToken: accessToken, 
            expiredAt: expiredAt
        );

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

      if (response.isMatch(HttpStatus.tooManyRequests)) {
        return LoginToManyRequest();
      }

      if (response.isMatch(HttpStatus.unauthorized, HttpStatus.accepted)) {
        return Login2FARequired(email: email, password: password);
      }

      if (response.isMatch(HttpStatus.unauthorized, HttpStatus.continue_)) {
        return LoginActiveRequired(email: email, password: password);
      }

      if (response.isMatch(HttpStatus.unauthorized, HttpStatus.notFound)) {
        return LoginFailed(message: "Account not exists!");
      }

      return LoginFailed(
          error: error,
          message: response.message ?? "Incorrect email or password!");
    } catch (error) {
      return LoginFailed(error: error as Exception, message: error.toString());
    }
  }

}
