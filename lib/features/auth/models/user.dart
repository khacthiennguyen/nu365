import 'package:json_annotation/json_annotation.dart';

part '../../../generated/features/auth/models/user.g.dart';

@JsonSerializable()
class User {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'email')
  final String email;

  @JsonKey(name: 'name')
  final String name;

  const User({
    required this.id,
    required this.email,
    required this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
