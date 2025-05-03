import 'dart:io';
import 'package:dio/dio.dart';
import 'package:nu365/core/api/dio/dio.dart' show dio;
import 'package:nu365/core/api/utils/base_response.dart';
import 'package:nu365/features/scan/logic/scan_state.dart';
import 'package:nu365/features/scan/models/output.dart';
import 'package:nu365/features/scan/models/prediction.dart';

class ScanService {
  static Future<ScanState> scanImage(File imageFile) async {
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        imageFile.path,
        filename: imageFile.path.split('/').last,
        contentType: DioMediaType('image', 'jpeg'),
      ),
    });
    BaseResponse response = BaseResponse.fromDIOResponse(
        await dio.post("detection/detect", data: formData));
    if (response.httpStatus == 200) {
      try {
        Outputs outputs = Outputs.fromJson(response.payload);
        // String weith = outputs.outputs[0].predictions.predictions[0].className;
        if (outputs.outputs[0].predictions.predictions.isEmpty) {
          return ScanFailure(
              message: 'Không nhận diện được ảnh',
              error: Exception("No predictions found"));
        }

        final List<Prediction> predictions =
            outputs.outputs[0].predictions.predictions;

        final List<Prediction> predictConfiAprove = predictions
            .where((prediction) => prediction.confidence >= 0.8)
            .toList();

        // filter confident >= 0.8
        if (predictConfiAprove.isEmpty) {
          return ScanFailure(
              message: 'Không nhận diện được ảnh',
              error: Exception("No predictions found"));
        }
        return ScanSuccess(
            predictions: predictConfiAprove, imageFile: imageFile);
      } catch (e) {
        return ScanFailure(
            message: 'Không nhận diện được ảnh', error: e as Exception);
      }
    }
    return ScanFailure(
        message: "Unexpected response from server",
        error: Exception("Unexpected response from server"));
  }
}
