import 'package:json_annotation/json_annotation.dart';

part 'role.g.dart';

@JsonSerializable()
class Role {
  int? roleid;
  String? name;
  String? shortname;
  int? sortorder;

  Role({this.roleid, this.name, this.shortname, this.sortorder});

  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);
  Map<String, dynamic> toJson() => _$RoleToJson(this);
}
