import 'package:json_annotation/json_annotation.dart';
import 'package:nu365/features/auth/models/user.dart';

part '../../../generated/features/auth/models/credentail.g.dart';

@JsonSerializable(explicitToJson: true)
class Credential {
  @JsonKey(name: 'session')
  final Session session;

  @JsonKey(name: 'user')
  final User user;

  const Credential({
    required this.session,
    required this.user,
  });

  factory Credential.fromJson(Map<String, dynamic> json) =>
      _$CredentialFromJson(json);

  Map<String, dynamic> toJson() => _$CredentialToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Session {
  @JsonKey(name: 'access_token')
  final String accessToken;

  @JsonKey(name: 'expires_at')
  final int expiresAt;

  const Session({
    required this.accessToken,
    required this.expiresAt,
  });

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);

  Map<String, dynamic> toJson() => _$SessionToJson(this);
}
