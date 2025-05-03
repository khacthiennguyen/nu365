// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../features/scan/models/output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Outputs _$OutputsFromJson(Map<String, dynamic> json) => Outputs(
      outputs: (json['outputs'] as List<dynamic>)
          .map((e) => Output.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OutputsToJson(Outputs instance) => <String, dynamic>{
      'outputs': instance.outputs,
    };

Output _$OutputFromJson(Map<String, dynamic> json) => Output(
      predictions: PredictionContainer.fromJson(
          json['predictions'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OutputToJson(Output instance) => <String, dynamic>{
      'predictions': instance.predictions,
    };

PredictionContainer _$PredictionContainerFromJson(Map<String, dynamic> json) =>
    PredictionContainer(
      image: Image.fromJson(json['image'] as Map<String, dynamic>),
      predictions: (json['predictions'] as List<dynamic>)
          .map((e) => Prediction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PredictionContainerToJson(
        PredictionContainer instance) =>
    <String, dynamic>{
      'image': instance.image,
      'predictions': instance.predictions,
    };

Image _$ImageFromJson(Map<String, dynamic> json) => Image(
      width: (json['width'] as num).toInt(),
      height: (json['height'] as num).toInt(),
    );

Map<String, dynamic> _$ImageToJson(Image instance) => <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
    };
