import 'package:json_annotation/json_annotation.dart';

import 'parameter.dart';

part 'lti.g.dart';

@JsonSerializable()
class Lti {
  String? endpoint;
  List<Parameter>? parameters;
  List<Map<String, dynamic>>? warnings;

  Lti({this.endpoint, this.parameters, this.warnings});

  factory Lti.fromJson(Map<String, dynamic> json) =>
      _$LtiFromJson(json);
  Map<String, dynamic> toJson() => _$LtiToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}