// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../features/history/models/food_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoodItem _$FoodItemFromJson(Map<String, dynamic> json) => FoodItem(
      food_id: json['food_id'] as String?,
      foodName: json['foodName'] as String,
      calories: (json['calories'] as num).toDouble(),
      protein: (json['protein'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
      carb: (json['carb'] as num).toDouble(),
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$FoodItemToJson(FoodItem instance) => <String, dynamic>{
      'food_id': instance.food_id,
      'foodName': instance.foodName,
      'calories': instance.calories,
      'protein': instance.protein,
      'fat': instance.fat,
      'carb': instance.carb,
      'quantity': instance.quantity,
    };
