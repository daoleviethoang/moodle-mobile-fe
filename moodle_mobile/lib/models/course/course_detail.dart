import 'package:json_annotation/json_annotation.dart';
import 'package:moodle_mobile/models/contact/contact.dart';

part 'course_detail.g.dart';

@JsonSerializable()
class CourseDetail {
  int? id;
  String? fullname;
  String? displayname;
  String? shortname;
  int? categoryid;
  String? categoryname;
  int? sortorder;
  String? summary;
  int? summaryformat;
  List<dynamic>? summaryfiles;
  List<dynamic>? overviewfiles;
  bool? showactivitydates;
  bool? showcompletionconditions;
  List<Contact>? contacts;
  List<String>? enrollmentmethods;

  CourseDetail({
    this.id,
    this.fullname,
    this.displayname,
    this.shortname,
    this.categoryid,
    this.categoryname,
    this.sortorder,
    this.summary,
    this.summaryformat,
    this.summaryfiles,
    this.overviewfiles,
    this.showactivitydates,
    this.showcompletionconditions,
    this.contacts,
    this.enrollmentmethods,
  });

  factory CourseDetail.fromJson(Map<String, dynamic> json) =>
      _$CourseDetailFromJson(json);

  Map<String, dynamic> toJson() => _$CourseDetailToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}