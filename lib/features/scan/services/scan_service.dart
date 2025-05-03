import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:nu365/core/api/dio/dio.dart' show dio;
import 'package:nu365/core/api/utils/base_response.dart';
import 'package:nu365/features/scan/logic/scan_state.dart';
import 'package:nu365/features/scan/models/output.dart';

class ScanService {
  static Future<ScanState> scanImage(File imageFile) async {
    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
          contentType: DioMediaType('image', 'jpeg'),
        ),
      });
      // print("path: ${imageFile.path}");
      // print("formData: ${formData.files}");
      BaseResponse response = BaseResponse.fromDIOResponse(
        await dio.post("detection/detect", data: formData),
      );
      print("response: ${response.payload.toString()}");
      Outputs outputs = Outputs.fromJson(response.payload);
      print("output: ${outputs.toString()}");
      String weith = outputs.outputs[0].predictions.predictions[0].className;
      print(weith);
      return ScanFailure(message: 'ok', error: null);
    } catch (e) {
      print("Exception: $e");
      return ScanFailure(
          message: 'Exception during scan catch: $e',
          error: e is Exception ? e : null);
    }
  }
}
