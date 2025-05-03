import 'package:json_annotation/json_annotation.dart';
import 'package:nu365/features/scan/models/prediction.dart';
part '../../../generated/features/scan/models/output.g.dart';

@JsonSerializable()
class Outputs {
  final List<Output> outputs;

  Outputs({required this.outputs});

  factory Outputs.fromJson(Map<String, dynamic> json) =>
      _$OutputsFromJson(json);

  Map<String, dynamic> toJson() => _$OutputsToJson(this);
}

@JsonSerializable()
class Output {
  final PredictionContainer predictions;

  Output({required this.predictions});

  factory Output.fromJson(Map<String, dynamic> json) => _$OutputFromJson(json);

  Map<String, dynamic> toJson() => _$OutputToJson(this);
}

@JsonSerializable()
class PredictionContainer {
  final Image image;
  final List<Prediction> predictions;

  PredictionContainer({required this.image, required this.predictions});

  factory PredictionContainer.fromJson(Map<String, dynamic> json) =>
      _$PredictionContainerFromJson(json);

  Map<String, dynamic> toJson() => _$PredictionContainerToJson(this);
}

@JsonSerializable()
class Image {
  final int width;
  final int height;

  Image({required this.width, required this.height});

  factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);

  Map<String, dynamic> toJson() => _$ImageToJson(this);
}
