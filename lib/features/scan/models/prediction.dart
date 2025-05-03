import 'package:json_annotation/json_annotation.dart';
part '../../../generated/features/scan/models/prediction.g.dart';

@JsonSerializable()

class Prediction {
  final int width;
  final int height;
  final double x;
  final double y;
  final double confidence;

  @JsonKey(name: 'class_id')
  final int classId;

  @JsonKey(name: 'class')
  final String className;

  @JsonKey(name: 'detection_id')
  final String detectionId;

  @JsonKey(name: 'parent_id')
  final String parentId;

  Prediction({
    required this.width,
    required this.height,
    required this.x,
    required this.y,
    required this.confidence,
    required this.classId,
    required this.className,
    required this.detectionId,
    required this.parentId,
  });

  factory Prediction.fromJson(Map<String, dynamic> json) =>
      _$PredictionFromJson(json);

  Map<String, dynamic> toJson() => _$PredictionToJson(this);
}
