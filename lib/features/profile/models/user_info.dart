import 'package:json_annotation/json_annotation.dart';
part '../../../generated/features/profile/models/user_info.g.dart';

@JsonSerializable()
class UserInfo {
  final String userId;
  final String email;

  @JsonKey(
      name: 'userName') 
  final String userName;

  final DateTime created_at;
  final DateTime? dayofbirth;
  final double? goal_calories;
  final double? goal_protein;
  final double? goal_fat;
  final double? goal_carbs;
  final String createdAt;

  UserInfo({
    required this.userId,
    required this.email,
    required this.userName,
    required this.created_at,
    this.dayofbirth,
    this.goal_calories,
    this.goal_protein,
    this.goal_fat,
    this.goal_carbs,
    required this.createdAt,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoToJson(this);

  // Thêm phương thức toString() để hỗ trợ debug
  @override
  String toString() {
    return 'UserInfo {'
        'userId: $userId, '
        'email: $email, '
        'userName: $userName, '
        'created_at: ${created_at.toIso8601String()}, '
        'dayofbirth: ${dayofbirth?.toIso8601String()}, '
        'goal_calories: $goal_calories, '
        'goal_protein: $goal_protein, '
        'goal_fat: $goal_fat, '
        'goal_carbs: $goal_carbs, '
        'createdAt: $createdAt'
        '}';
  }

  // Thêm phương thức toJsonString để debug mà không phụ thuộc vào mã sinh tự động
  String toJsonString() {
    return '{'
        '"userId": "$userId", '
        '"email": "$email", '
        '"userName": "$userName", '
        '"created_at": "${created_at.toIso8601String()}", '
        '"dayofbirth": "${dayofbirth?.toIso8601String()}", '
        '"goal_calories": $goal_calories, '
        '"goal_protein": $goal_protein, '
        '"goal_fat": $goal_fat, '
        '"goal_carbs": $goal_carbs, '
        '"createdAt": "$createdAt"'
        '}';
  }
}
