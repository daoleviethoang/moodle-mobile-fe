import 'package:json_annotation/json_annotation.dart';

part 'enrolled_course.g.dart';

@JsonSerializable()
class EnrolledCourse {
  int? id;
  String? fullname;
  String? shortname;

  EnrolledCourse({this.id, this.fullname, this.shortname});

  factory EnrolledCourse.fromJson(Map<String, dynamic> json) =>
      _$EnrolledCourseFromJson(json);
  Map<String, dynamic> toJson() => _$EnrolledCourseToJson(this);
}
