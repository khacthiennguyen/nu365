import 'package:dio/dio.dart';

class BaseResponse {
  bool error = false;
  bool success = false;
  int code = 0;
  int httpStatus = 0;
  dynamic payload;
  dynamic message;
  dynamic meta;

  BaseResponse(
      {required this.error,
      required this.success,
      required this.code,
      required this.httpStatus,
      this.payload,
      this.message,
      this.meta});

  BaseResponse.fromDIOResponse(Response response) {
    final data = response.data;
    if (data == null || data is! Map<String, dynamic>) {
      error = true;
      success = false;
      code = 0;
      httpStatus = response.statusCode ?? 0;
      return;
    }

    error = data["error"] ?? false;
    success = data["success"] ?? false;
    code = data["code"] ?? 0;
    httpStatus = data["httpStatus"] ?? response.statusCode ?? 0;
    payload = data["payload"];
    message = data["message"];
    meta = data["meta"];
  }

  bool isMatch(httpStatus, [code]) {
    if (code != null) {
      return this.httpStatus == httpStatus && this.code == code;
    }
    return this.httpStatus == httpStatus;
  }

  BaseResponse.fromJson(Map<String, dynamic> json) {
    error = json["error"] ?? false;
    success = json["success"] ?? false;
    code = json["code"] ?? 0;
    httpStatus = json["httpStatus"] ?? 0;
    payload = json["payload"];
    message = json["message"];
    meta = json["meta"];
  }

  Map<String, dynamic> toJson() => {
        "error": error,
        "success": success,
        "code": code,
        "httpStatus": httpStatus,
        "payload": payload,
        "message": message,
        "meta": meta
      };
}
