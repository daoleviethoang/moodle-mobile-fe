// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enrolled_course.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EnrolledCourse _$EnrolledCourseFromJson(Map<String, dynamic> json) =>
    EnrolledCourse(
      id: json['id'] as int?,
      fullname: json['fullname'] as String?,
      shortname: json['shortname'] as String?,
    );

Map<String, dynamic> _$EnrolledCourseToJson(EnrolledCourse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullname': instance.fullname,
      'shortname': instance.shortname,
    };
