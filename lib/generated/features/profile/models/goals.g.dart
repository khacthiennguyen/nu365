// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../features/profile/models/goals.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Goals _$GoalsFromJson(Map<String, dynamic> json) => Goals(
      goal_carbs: (json['goal_carbs'] as num).toDouble(),
      goal_fat: (json['goal_fat'] as num).toDouble(),
      goal_protein: (json['goal_protein'] as num).toDouble(),
      goal_calories: (json['goal_calories'] as num).toDouble(),
    );

Map<String, dynamic> _$GoalsToJson(Goals instance) => <String, dynamic>{
      'goal_carbs': instance.goal_carbs,
      'goal_fat': instance.goal_fat,
      'goal_protein': instance.goal_protein,
      'goal_calories': instance.goal_calories,
    };
