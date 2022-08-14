import 'package:json_annotation/json_annotation.dart';
import 'package:moodle_mobile/models/contact/contact.dart';

part 'course_category_course.g.dart';

@JsonSerializable()
class CourseCategoryCourse {
  final int id;
  final String displayname;
  @JsonKey(nullable: true)
  final List<Contact>? contacts;

  CourseCategoryCourse({this.id = 0, this.displayname = "", this.contacts});
  factory CourseCategoryCourse.fromJson(Map<String, dynamic> json) =>
      _$CourseCategoryCourseFromJson(json);
  Map<String, dynamic> toJson() => _$CourseCategoryCourseToJson(this);
}