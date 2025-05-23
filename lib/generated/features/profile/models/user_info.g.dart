// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../features/profile/models/user_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) => UserInfo(
      userId: json['userId'] as String,
      email: json['email'] as String,
      userName: json['userName'] as String,
      created_at: DateTime.parse(json['created_at'] as String),
      dayofbirth: json['dayofbirth'] == null
          ? null
          : DateTime.parse(json['dayofbirth'] as String),
      goal_calories: (json['goal_calories'] as num?)?.toDouble(),
      goal_protein: (json['goal_protein'] as num?)?.toDouble(),
      goal_fat: (json['goal_fat'] as num?)?.toDouble(),
      goal_carbs: (json['goal_carbs'] as num?)?.toDouble(),
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'userId': instance.userId,
      'email': instance.email,
      'userName': instance.userName,
      'created_at': instance.created_at.toIso8601String(),
      'dayofbirth': instance.dayofbirth?.toIso8601String(),
      'goal_calories': instance.goal_calories,
      'goal_protein': instance.goal_protein,
      'goal_fat': instance.goal_fat,
      'goal_carbs': instance.goal_carbs,
      'createdAt': instance.createdAt,
    };
