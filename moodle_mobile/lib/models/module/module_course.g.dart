// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module_course.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModuleCourse _$ModuleCourseFromJson(Map<String, dynamic> json) => ModuleCourse(
      id: json['id'] as int?,
      course: json['course'] as int?,
      module: json['module'] as int?,
      name: json['name'] as String?,
      modname: json['modname'] as String?,
      instance: json['instance'] as int?,
      section: json['section'] as int?,
      sectionnum: json['sectionnum'] as int?,
      groupmode: json['groupmode'] as int?,
      groupingid: json['groupingid'] as int?,
      completion: json['completion'] as int?,
    );

Map<String, dynamic> _$ModuleCourseToJson(ModuleCourse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'course': instance.course,
      'module': instance.module,
      'name': instance.name,
      'modname': instance.modname,
      'instance': instance.instance,
      'section': instance.section,
      'sectionnum': instance.sectionnum,
      'groupmode': instance.groupmode,
      'groupingid': instance.groupingid,
      'completion': instance.completion,
    };
