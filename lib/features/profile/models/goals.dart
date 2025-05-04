import 'package:json_annotation/json_annotation.dart';
part '../../../generated/features/profile/models/goals.g.dart';

@JsonSerializable()
class Goals {
  final double goal_carbs;
  final double goal_fat;
  final double goal_protein;
  final double goal_calories;
  Goals({
    required this.goal_carbs,
    required this.goal_fat,
    required this.goal_protein,
    required this.goal_calories,
  });
  factory Goals.fromJson(Map<String, dynamic> json) => _$GoalsFromJson(json);
  Map<String, dynamic> toJson() => _$GoalsToJson(this);
}
