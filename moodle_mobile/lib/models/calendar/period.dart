import 'package:json_annotation/json_annotation.dart';

part 'period.g.dart';

@JsonSerializable()
class Period {
  int? seconds;
  int? minutes;
  int? hours;
  int? mday;
  int? wday;
  int? mon;
  int? year;
  int? yday;
  String? weekday;
  String? month;
  int? timestamp;

  Period({
    this.seconds,
    this.minutes,
    this.hours,
    this.mday,
    this.wday,
    this.mon,
    this.year,
    this.yday,
    this.weekday,
    this.month,
    this.timestamp,
  });

  factory Period.fromJson(Map<String, dynamic> json) => _$PeriodFromJson(json);

  Map<String, dynamic> toJson() => _$PeriodToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}