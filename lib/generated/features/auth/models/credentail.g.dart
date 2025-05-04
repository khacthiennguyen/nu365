// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../features/auth/models/credentail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Credential _$CredentialFromJson(Map<String, dynamic> json) => Credential(
      session: Session.fromJson(json['session'] as Map<String, dynamic>),
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CredentialToJson(Credential instance) =>
    <String, dynamic>{
      'session': instance.session.toJson(),
      'user': instance.user.toJson(),
    };

Session _$SessionFromJson(Map<String, dynamic> json) => Session(
      accessToken: json['access_token'] as String,
      expiresAt: (json['expires_at'] as num).toInt(),
    );

Map<String, dynamic> _$SessionToJson(Session instance) => <String, dynamic>{
      'access_token': instance.accessToken,
      'expires_at': instance.expiresAt,
    };
