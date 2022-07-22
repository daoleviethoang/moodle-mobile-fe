// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'imgur_auth_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImgurAuthToken _$ImgurAuthTokenFromJson(Map<String, dynamic> json) =>
    ImgurAuthToken(
      refresh_token: json['refresh_token'] as String?,
      client_id: json['client_id'] as String?,
      client_secret: json['client_secret'] as String?,
      grant_type: json['grant_type'] as String?,
    );

Map<String, dynamic> _$ImgurAuthTokenToJson(ImgurAuthToken instance) =>
    <String, dynamic>{
      'refresh_token': instance.refresh_token,
      'client_id': instance.client_id,
      'client_secret': instance.client_secret,
      'grant_type': instance.grant_type,
    };
