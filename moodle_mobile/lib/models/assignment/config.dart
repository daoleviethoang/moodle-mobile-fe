import 'package:json_annotation/json_annotation.dart';

part 'config.g.dart';

@JsonSerializable()
class ConfigsAssignment {
  String plugin;
  String subtype;
  String name;
  String value;

  ConfigsAssignment(
      {this.plugin = "", this.subtype = "", this.name = "", this.value = ""});
  factory ConfigsAssignment.fromJson(Map<String, dynamic> json) =>
    _$ConfigsAssignmentFromJson(json);
  Map<String, dynamic> toJson() => _$ConfigsAssignmentToJson(this);
}
