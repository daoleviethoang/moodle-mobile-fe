// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_category_course.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseCategoryCourse _$CourseCategoryCourseFromJson(
        Map<String, dynamic> json) =>
    CourseCategoryCourse(
      id: json['id'] as int? ?? 0,
      displayname: json['displayname'] as String? ?? "",
      contacts: (json['contacts'] as List<dynamic>?)
          ?.map((e) => Contact.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CourseCategoryCourseToJson(
        CourseCategoryCourse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'displayname': instance.displayname,
      'contacts': instance.contacts,
    };
