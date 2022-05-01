// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseCategory _$CourseCategoryFromJson(Map<String, dynamic> json) =>
    CourseCategory(
      json['id'] as int,
      json['name'] as String,
      json['description'] as String,
      json['descriptionformat'] as int,
      json['parent'] as int,
      json['sortorder'] as int,
      json['coursecount'] as int,
      json['depth'] as int,
      json['path'] as String,
      json['sumCoursecount'] as int,
    );

Map<String, dynamic> _$CourseCategoryToJson(CourseCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'descriptionformat': instance.descriptionformat,
      'parent': instance.parent,
      'sortorder': instance.sortorder,
      'coursecount': instance.coursecount,
      'depth': instance.depth,
      'path': instance.path,
      'sumCoursecount': instance.sumCoursecount,
    };
