import 'package:json_annotation/json_annotation.dart';

part 'completiondata.g.dart';

@JsonSerializable()
class Completiondata {
  int? state;
  int? timecompleted;
  Null? overrideby;
  bool? valueused;
  bool? hascompletion;
  bool? isautomatic;
  bool? istrackeduser;
  bool? uservisible;
  List<dynamic>? details;

  Completiondata({this.state,
    this.timecompleted,
    this.overrideby,
    this.valueused,
    this.hascompletion,
    this.isautomatic,
    this.istrackeduser,
    this.uservisible,
    this.details});

  factory Completiondata.fromJson(Map<String, dynamic> json) =>
      _$CompletiondataFromJson(json);
  Map<String, dynamic> toJson() => _$CompletiondataToJson(this);
}