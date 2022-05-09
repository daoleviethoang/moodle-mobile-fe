import 'package:json_annotation/json_annotation.dart';

import 'day.dart';

part 'week.g.dart';

@JsonSerializable()
class Week {
  List<int>? prepadding;
  List<int>? postpadding;
  List<Day>? days;

  Week({this.prepadding, this.postpadding, this.days});

  factory Week.fromJson(Map<String, dynamic> json) => _$WeekFromJson(json);

  Map<String, dynamic> toJson() => _$WeekToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}