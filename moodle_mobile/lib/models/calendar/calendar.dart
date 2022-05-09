import 'package:json_annotation/json_annotation.dart';

import 'day.dart';
import 'period.dart';
import 'week.dart';

part 'calendar.g.dart';

@JsonSerializable()
class Calendar {
  String? url;
  int? courseid;
  int? categoryid;
  String? filterSelector;
  List<Week>? weeks;
  List<DayName>? daynames;
  String? view;
  Period? date;
  String? periodname;
  bool? includenavigation;
  bool? initialeventsloaded;
  Period? previousperiod;
  String? previousperiodlink;
  String? previousperiodname;
  Period? nextperiod;
  String? nextperiodname;
  String? nextperiodlink;
  String? larrow;
  String? rarrow;
  int? defaulteventcontext;

  Calendar({
    this.url,
    this.courseid,
    this.categoryid,
    this.filterSelector,
    this.weeks,
    this.daynames,
    this.view,
    this.date,
    this.periodname,
    this.includenavigation,
    this.initialeventsloaded,
    this.previousperiod,
    this.previousperiodlink,
    this.previousperiodname,
    this.nextperiod,
    this.nextperiodname,
    this.nextperiodlink,
    this.larrow,
    this.rarrow,
    this.defaulteventcontext,
  });

  factory Calendar.fromJson(Map<String, dynamic> json) => _$CalendarFromJson(json);

  Map<String, dynamic> toJson() => _$CalendarToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

@JsonSerializable()
class CalendarIcon {
  String? key;
  String? component;
  String? alttext;

  CalendarIcon({this.key, this.component, this.alttext});

  factory CalendarIcon.fromJson(Map<String, dynamic> json) => _$CalendarIconFromJson(json);

  Map<String, dynamic> toJson() => _$CalendarIconToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}