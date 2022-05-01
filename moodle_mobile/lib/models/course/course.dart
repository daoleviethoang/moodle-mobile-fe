import 'package:json_annotation/json_annotation.dart';

part 'course.g.dart';

@JsonSerializable()
class Course {
  int id;
  String? shortname;
  String? fullname;
  String? displayname;
  int? enrolledusercount;
  String? idnumber;
  int? visible;
  String? summary;
  int? summaryformat;
  String? format;
  bool? showgrades;
  String? lang;
  bool? enablecompletion;
  bool? completionhascriteria;
  bool? completionusertracked;
  int? category;
  double? progress;
  bool? completed;
  int? startdate;
  int? enddate;
  int? marker;
  int? lastaccess;
  bool? isfavourite;
  bool? hidden;
  bool? showactivitydates;
  bool? showcompletionconditions;

  Course({
    required this.id,
    this.shortname,
    this.fullname,
    this.displayname,
    this.enrolledusercount,
    this.idnumber,
    this.visible,
    this.summary,
    this.summaryformat,
    this.format,
    this.showgrades,
    this.lang,
    this.enablecompletion,
    this.completionhascriteria,
    this.completionusertracked,
    this.category,
    this.progress,
    this.completed,
    this.startdate,
    this.enddate,
    this.marker,
    this.lastaccess,
    this.isfavourite,
    this.hidden,
    this.showactivitydates,
    this.showcompletionconditions,
  });
  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);
  Map<String, dynamic> toJson() => _$CourseToJson(this);
}
