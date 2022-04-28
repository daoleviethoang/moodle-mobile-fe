import 'package:json_annotation/json_annotation.dart';

part 'course_category.g.dart';

@JsonSerializable()
class CourseCategory {
  final int id;
  final String name;
  final String description;
  final int descriptionformat;
  final int parent;
  final int sortorder;
  final int coursecount;
  final int depth;
  final String path;
  int sumCoursecount = 0;

  @JsonKey(ignore: true)
  List<CourseCategory> child = [];

  void addChild(courseCategory) {
    child.add(courseCategory);
  }

  CourseCategory(
      this.id,
      this.name,
      this.description,
      this.descriptionformat,
      this.parent,
      this.sortorder,
      this.coursecount,
      this.depth,
      this.path,
      this.sumCoursecount);
  factory CourseCategory.fromJson(Map<String, dynamic> json) =>
      _$CourseCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CourseCategoryToJson(this);
}
