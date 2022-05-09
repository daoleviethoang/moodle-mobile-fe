import 'package:json_annotation/json_annotation.dart';

import 'event.dart';

part 'day.g.dart';

@JsonSerializable()
class Day {
  int? seconds;
  int? minutes;
  int? hours;
  int? mday;
  int? wday;
  int? year;
  int? yday;
  bool? istoday;
  bool? isweekend;
  int? timestamp;
  int? neweventtimestamp;
  String? viewdaylink;
  List<Event>? events;
  bool? hasevents;
  List<String>? calendareventtypes;
  int? previousperiod;
  int? nextperiod;
  String? navigation;
  bool? haslastdayofevent;
  String? popovertitle;
  String? daytitle;
  String? viewdaylinktitle;

  Day(
      {this.seconds,
        this.minutes,
        this.hours,
        this.mday,
        this.wday,
        this.year,
        this.yday,
        this.istoday,
        this.isweekend,
        this.timestamp,
        this.neweventtimestamp,
        this.viewdaylink,
        this.events,
        this.hasevents,
        this.calendareventtypes,
        this.previousperiod,
        this.nextperiod,
        this.navigation,
        this.haslastdayofevent,
        this.popovertitle,
        this.daytitle,
        this.viewdaylinktitle,});

  factory Day.fromJson(Map<String, dynamic> json) => _$DayFromJson(json);

  Map<String, dynamic> toJson() => _$DayToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

@JsonSerializable()
class DayName {
  int? dayno;
  String? shortname;
  String? fullname;

  DayName({this.dayno, this.shortname, this.fullname});

  factory DayName.fromJson(Map<String, dynamic> json) => _$DayNameFromJson(json);

  Map<String, dynamic> toJson() => _$DayNameToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}