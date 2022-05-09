import 'package:json_annotation/json_annotation.dart';
import 'package:moodle_mobile/models/enrolled_course/enrolled_course.dart';
import 'package:moodle_mobile/models/role/role.dart';

part 'contact.g.dart';

@JsonSerializable()
class Contact {
  int id;
  String fullname;

  Contact({
    required this.id,
    required this.fullname,
  });
  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);
  Map<String, dynamic> toJson() => _$ContactToJson(this);
}
