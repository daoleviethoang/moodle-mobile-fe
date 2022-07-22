// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'imgur_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImgurToken _$ImgurTokenFromJson(Map<String, dynamic> json) => ImgurToken(
      access_token: json['access_token'] as String?,
      expires_in: json['expires_in'] as int?,
      token_type: json['token_type'] as String?,
      scope: json['scope'] as int?,
      refresh_token: json['refresh_token'] as String?,
      account_id: json['account_id'] as int?,
      account_username: json['account_username'] as String?,
    );

Map<String, dynamic> _$ImgurTokenToJson(ImgurToken instance) =>
    <String, dynamic>{
      'access_token': instance.access_token,
      'expires_in': instance.expires_in,
      'token_type': instance.token_type,
      'scope': instance.scope,
      'refresh_token': instance.refresh_token,
      'account_id': instance.account_id,
      'account_username': instance.account_username,
    };
