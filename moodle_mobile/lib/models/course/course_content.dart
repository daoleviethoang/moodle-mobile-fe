import 'package:json_annotation/json_annotation.dart';

import '../module/module.dart';

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
  final List<Module> modules;

  CourseContent(
      this.id,
      this.name,
      this.visible,
      this.summary,
      this.summaryformat,
      this.section,
      this.hiddenbynumsections,
      this.uservisible,
      this.modules,
      );

  factory CourseContent.fromJson(Map<String, dynamic> json) =>
      _$CourseContentFromJson(json);
  Map<String, dynamic> toJson() => _$CourseContentToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}