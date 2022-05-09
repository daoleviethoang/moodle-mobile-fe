import 'package:json_annotation/json_annotation.dart';

part 'module_course.g.dart';

@JsonSerializable()
class ModuleCourse {
  int? id;
  int? course;
  int? module;
  String? name;
  String? modname;
  int? instance;
  int? section;
  int? sectionnum;
  int? groupmode;
  int? groupingid;
  int? completion;

  ModuleCourse({
    this.id,
    this.course,
    this.module,
    this.name,
    this.modname,
    this.instance,
    this.section,
    this.sectionnum,
    this.groupmode,
    this.groupingid,
    this.completion,
  });

  factory ModuleCourse.fromJson(Map<String, dynamic> json) =>
      _$ModuleCourseFromJson(json);
  Map<String, dynamic> toJson() => _$ModuleCourseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}