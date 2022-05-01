import 'package:json_annotation/json_annotation.dart';
import 'package:moodle_mobile/models/enrolled_course/enrolled_course.dart';
import 'package:moodle_mobile/models/role/role.dart';

part 'contact.g.dart';

@JsonSerializable()
class Contact {
  int id;
  String fullname;
  String? email;
  int? firstaccess;
  int? lastaccess;
  int? lastcourseaccess;
  String? description;
  int? descriptionformat;
  String? city;
  String? country;
  String? profileimageurlsmall;
  String? profileimageurl;
  List<Role>? roles;
  List<EnrolledCourse>? enrolledcourses;

  Contact(
      {required this.id,
      required this.fullname,
      this.email,
      this.firstaccess,
      this.lastaccess,
      this.lastcourseaccess,
      this.description,
      this.descriptionformat,
      this.city,
      this.country,
      this.profileimageurlsmall,
      this.profileimageurl,
      this.roles,
      this.enrolledcourses});
  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);
  Map<String, dynamic> toJson() => _$ContactToJson(this);
}
