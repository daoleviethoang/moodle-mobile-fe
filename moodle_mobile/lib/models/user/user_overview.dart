import 'package:json_annotation/json_annotation.dart';

part 'user_overview.g.dart';

@JsonSerializable()
class UserOverview {
  UserOverview({this.id = 0, this.name = ''});

  int id;
  String name;

  factory UserOverview.fromJson(Map<String, dynamic> json) =>
      _$UserOverviewFromJson(json);
  Map<String, dynamic> toJson() => _$UserOverviewToJson(this);
}
