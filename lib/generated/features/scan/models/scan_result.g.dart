// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../features/scan/models/scan_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoodInfo _$FoodInfoFromJson(Map<String, dynamic> json) => FoodInfo(
      foodName: json['foodName'] as String,
      calories: (json['calories'] as num).toDouble(),
      protein: (json['protein'] as num).toDouble(),
      carb: (json['carb'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
    );

Map<String, dynamic> _$FoodInfoToJson(FoodInfo instance) => <String, dynamic>{
      'foodName': instance.foodName,
      'calories': instance.calories,
      'protein': instance.protein,
      'carb': instance.carb,
      'fat': instance.fat,
    };
