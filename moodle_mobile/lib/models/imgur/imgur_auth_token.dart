// ignore_for_file: non_constant_identifier_names
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'imgur_auth_token.g.dart';

@JsonSerializable()
class ImgurAuthToken {
  final String? refresh_token;
  final String? client_id;
  final String? client_secret;
  final String? grant_type;

  ImgurAuthToken({
    this.refresh_token,
    this.client_id,
    this.client_secret,
    this.grant_type,
  });

  factory ImgurAuthToken.fromJson(Map<String, dynamic> json) =>
      _$ImgurAuthTokenFromJson(json);

  Map<String, dynamic> toJson() => _$ImgurAuthTokenToJson(this);

  @override
  String toString() => jsonEncode(toJson());
}