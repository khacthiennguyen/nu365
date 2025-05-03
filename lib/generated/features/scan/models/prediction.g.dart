// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../features/scan/models/prediction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Prediction _$PredictionFromJson(Map<String, dynamic> json) => Prediction(
      width: (json['width'] as num).toInt(),
      height: (json['height'] as num).toInt(),
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      confidence: (json['confidence'] as num).toDouble(),
      classId: (json['class_id'] as num).toInt(),
      className: json['class'] as String,
      detectionId: json['detection_id'] as String,
      parentId: json['parent_id'] as String,
    );

Map<String, dynamic> _$PredictionToJson(Prediction instance) =>
    <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
      'x': instance.x,
      'y': instance.y,
      'confidence': instance.confidence,
      'class_id': instance.classId,
      'class': instance.className,
      'detection_id': instance.detectionId,
      'parent_id': instance.parentId,
    };
