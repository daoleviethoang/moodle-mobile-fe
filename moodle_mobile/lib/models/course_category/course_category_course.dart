import 'package:json_annotation/json_annotation.dart';

part 'course_category_course.g.dart';

@JsonSerializable()
class CourseCategoryCourse {
  final int id;
  final String displayname;

  CourseCategoryCourse(this.id, this.displayname);
  factory CourseCategoryCourse.fromJson(Map<String, dynamic> json) =>
      _$CourseCategoryCourseFromJson(json);
  Map<String, dynamic> toJson() => _$CourseCategoryCourseToJson(this);
}
