import 'package:json_annotation/json_annotation.dart';

part 'parameter.g.dart';

@JsonSerializable()
class Parameter {
  String? name;
  String? value;

  Parameter({this.name, this.value});

  factory Parameter.fromJson(Map<String, dynamic> json) =>
      _$ParameterFromJson(json);
  Map<String, dynamic> toJson() => _$ParameterToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}