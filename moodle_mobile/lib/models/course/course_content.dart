import 'package:json_annotation/json_annotation.dart';

part 'course_content.g.dart';

@JsonSerializable()
class CourseContent {
  final int id;
  final String name;
  final int visible;
  final String summary;
  final int summaryformat;
  final int section;
  final int hiddenbynumsections;
  final bool uservisible;
  final List<dynamic> modules;

  /*
   "id": 10390,
        "name": "General",
        "visible": 1,
        "summary": "",
        "summaryformat": 1,
        "section": 0,
        "hiddenbynumsections": 0,
        "uservisible": true,
        "modules"
   */

  CourseContent(
      this.id,
      this.name,
      this.visible,
      this.summary,
      this.summaryformat,
      this.section,
      this.hiddenbynumsections,
      this.uservisible,
      this.modules);

  factory CourseContent.fromJson(Map<String, dynamic> json) =>
      _$CourseContentFromJson(json);
  Map<String, dynamic> toJson() => _$CourseContentToJson(this);
}