import 'package:json_annotation/json_annotation.dart';
import 'package:moodle_mobile/models/course_category/course_category_course.dart';
import 'package:moodle_mobile/models/module/module_course.dart';

import 'calendar.dart';
import 'calendar_subscription.dart';

part 'event.g.dart';

@JsonSerializable()
class Event {
  int? id;
  String? name;
  String? description;
  int? descriptionformat;
  String? location;
  int? categoryid;
  int? groupid;
  int? courseid;
  int? userid;
  int? repeatid;
  int? eventcount;
  String? component;
  String? modulename;
  int? instance;
  String? eventtype;
  int? timestart;
  int? timeduration;
  int? timesort;
  int? timeusermidnight;
  int? visible;
  int? timemodified;
  CalendarIcon? icon;
  CourseCategoryCourse? course;
  CalendarSubscription? subscription;
  bool? canedit;
  bool? candelete;
  String? deleteurl;
  String? editurl;
  String? viewurl;
  String? formattedtime;
  bool? isactionevent;
  bool? iscourseevent;
  bool? iscategoryevent;
  String? groupname;
  String? normalisedeventtype;
  String? normalisedeventtypetext;
  String? url;
  bool? islastday;
  String? popupname;
  int? mindaytimestamp;
  String? mindayerror;
  int? maxdaytimestamp;
  String? maxdayerror;
  bool? draggable;
  ModuleCourse? cm;
  int? format;

  Event({
    this.id,
    this.name,
    this.description,
    this.descriptionformat,
    this.location,
    this.categoryid,
    this.groupid,
    this.courseid,
    this.userid,
    this.repeatid,
    this.eventcount,
    this.component,
    this.modulename,
    this.instance,
    this.eventtype,
    this.timestart,
    this.timeduration,
    this.timesort,
    this.timeusermidnight,
    this.visible,
    this.timemodified,
    this.icon,
    this.course,
    this.subscription,
    this.canedit,
    this.candelete,
    this.deleteurl,
    this.editurl,
    this.viewurl,
    this.formattedtime,
    this.isactionevent,
    this.iscourseevent,
    this.iscategoryevent,
    this.groupname,
    this.normalisedeventtype,
    this.normalisedeventtypetext,
    this.url,
    this.islastday,
    this.popupname,
    this.mindaytimestamp,
    this.mindayerror,
    this.maxdaytimestamp,
    this.maxdayerror,
    this.draggable,
    this.cm,
  this.format,
  });

  bool get isEmpty => name?.isEmpty ?? true;

  bool get isNotEmpty => !isEmpty;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  Map<String, dynamic> toJson() => _$EventToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

  @override
  bool operator == (Object other) {
    return other is Event && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}