import 'package:json_annotation/json_annotation.dart';

part 'course_category.g.dart';

@JsonSerializable()
class CourseCategory {
  int? id;
  String? name;
  String? description;
  int? descriptionformat;
  int? parent;
  int? sortorder;
  int? coursecount;
  int? depth;
  String? path;
  @JsonKey(ignore: true)
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
  );
  factory CourseCategory.fromJson(Map<String, dynamic> json) =>
      _$CourseCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CourseCategoryToJson(this);
}
