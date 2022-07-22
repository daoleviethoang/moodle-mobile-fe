// ignore_for_file: non_constant_identifier_names
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'imgur_token.g.dart';

@JsonSerializable()
class ImgurToken {
  final String? access_token;
  final int? expires_in;
  final String? token_type;
  final int? scope;
  final String? refresh_token;
  final int? account_id;
  final String? account_username;

  DateTime? get expireDate {
    if (expires_in == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(expires_in! * 1000);
  }

  ImgurToken({
    this.access_token,
    this.expires_in,
    this.token_type,
    this.scope,
    this.refresh_token,
    this.account_id,
    this.account_username,
  });

  factory ImgurToken.fromJson(Map<String, dynamic> json) =>
      _$ImgurTokenFromJson(json);

  Map<String, dynamic> toJson() => _$ImgurTokenToJson(this);

  @override
  String toString() => jsonEncode(toJson());
}