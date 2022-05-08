// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseDetail _$CourseDetailFromJson(Map<String, dynamic> json) => CourseDetail(
      id: json['id'] as int?,
      fullname: json['fullname'] as String?,
      displayname: json['displayname'] as String?,
      shortname: json['shortname'] as String?,
      categoryid: json['categoryid'] as int?,
      categoryname: json['categoryname'] as String?,
      sortorder: json['sortorder'] as int?,
      summary: json['summary'] as String?,
      summaryformat: json['summaryformat'] as int?,
      summaryfiles: json['summaryfiles'] as List<dynamic>?,
      overviewfiles: json['overviewfiles'] as List<dynamic>?,
      showactivitydates: json['showactivitydates'] as bool?,
      showcompletionconditions: json['showcompletionconditions'] as bool?,
      contacts: (json['contacts'] as List<dynamic>?)
          ?.map((e) => Contact.fromJson(e as Map<String, dynamic>))
          .toList(),
      enrollmentmethods: (json['enrollmentmethods'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$CourseDetailToJson(CourseDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullname': instance.fullname,
      'displayname': instance.displayname,
      'shortname': instance.shortname,
      'categoryid': instance.categoryid,
      'categoryname': instance.categoryname,
      'sortorder': instance.sortorder,
      'summary': instance.summary,
      'summaryformat': instance.summaryformat,
      'summaryfiles': instance.summaryfiles,
      'overviewfiles': instance.overviewfiles,
      'showactivitydates': instance.showactivitydates,
      'showcompletionconditions': instance.showcompletionconditions,
      'contacts': instance.contacts,
      'enrollmentmethods': instance.enrollmentmethods,
    };
