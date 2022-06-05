import 'package:json_annotation/json_annotation.dart';

part 'user_overview.g.dart';

@JsonSerializable()
class UserOverview {
  int? id;
  String? fullname;
  String? email;
  int? firstaccess;
  int? lastaccess;
  bool? suspended;
  String? description;
  int? descriptionformat;
  String? profileimageurlsmall;
  String? profileimageurl;
  String? city;
  String? country;

  UserOverview(
      {this.id,
      this.fullname,
      this.email,
      this.firstaccess,
      this.lastaccess,
      this.suspended,
      this.description,
      this.descriptionformat,
      this.profileimageurlsmall,
      this.profileimageurl,
      this.city,
      this.country});

  factory UserOverview.fromJson(Map<String, dynamic> json) =>
      _$UserOverviewFromJson(json);
  Map<String, dynamic> toJson() => _$UserOverviewToJson(this);
}
