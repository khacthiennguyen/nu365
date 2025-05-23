// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../features/history/models/meal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MealModel _$MealModelFromJson(Map<String, dynamic> json) => MealModel(
      meal_id: json['meal_id'] as String,
      meal_time: DateTime.parse(json['meal_time'] as String),
      note: json['note'] as String?,
      image_url: json['image_url'] as String?,
      food_items: (json['food_items'] as List<dynamic>?)
          ?.map((e) => FoodItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      total_calories: (json['total_calories'] as num?)?.toDouble(),
      total_protein: (json['total_protein'] as num?)?.toDouble(),
      total_fat: (json['total_fat'] as num?)?.toDouble(),
      total_carb: (json['total_carb'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$MealModelToJson(MealModel instance) => <String, dynamic>{
      'meal_id': instance.meal_id,
      'meal_time': instance.meal_time.toIso8601String(),
      'note': instance.note,
      'image_url': instance.image_url,
      'food_items': instance.food_items?.map((e) => e.toJson()).toList(),
      'total_calories': instance.total_calories,
      'total_protein': instance.total_protein,
      'total_fat': instance.total_fat,
      'total_carb': instance.total_carb,
    };
