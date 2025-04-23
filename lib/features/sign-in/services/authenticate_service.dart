import 'dart:io';

import 'package:dio/dio.dart';
import 'package:nu365/core/api/dio/dio.dart' show dio;
import 'package:nu365/core/api/utils/base_response.dart';
import 'package:nu365/features/sign-in/logic/login_state.dart';
import 'package:nu365/features/sign-in/models/credentail.dart';

class AuthenticateService {
  static Future<LoginState> login(String email, String password) async {
    try {
      BaseResponse response = BaseResponse.fromDIOResponse(await dio
          .post("auth/login", data: {"email": email, "password": password}));
      // print('Response payload: ${response.payload}');
      // print('Response payload type: ${response.payload.runtimeType}');

      // // If payload is a Map, print its keys to help with debugging
      // if (response.payload is Map) {
      //   print('Payload keys: ${(response.payload as Map).keys.toList()}');
      // }
      if (response.httpStatus == 200) {
        if (response.payload == null) {
          return LoginFailed(message: "Invalid response from server");
        }
        try {
          return LoginSuccess(
              credential: Credential.fromJson(response.payload));
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
