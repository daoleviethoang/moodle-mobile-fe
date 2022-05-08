// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Course _$CourseFromJson(Map<String, dynamic> json) => Course(
      id: json['id'] as int,
      shortname: json['shortname'] as String?,
      fullname: json['fullname'] as String?,
      displayname: json['displayname'] as String?,
      enrolledusercount: json['enrolledusercount'] as int?,
      idnumber: json['idnumber'] as String?,
      visible: json['visible'] as int?,
      summary: json['summary'] as String?,
      summaryformat: json['summaryformat'] as int?,
      format: json['format'] as String?,
      showgrades: json['showgrades'] as bool?,
      lang: json['lang'] as String?,
      enablecompletion: json['enablecompletion'] as bool?,
      completionhascriteria: json['completionhascriteria'] as bool?,
      completionusertracked: json['completionusertracked'] as bool?,
      category: json['category'] as int?,
      progress: (json['progress'] as num?)?.toDouble(),
      completed: json['completed'] as bool?,
      startdate: json['startdate'] as int?,
      enddate: json['enddate'] as int?,
      marker: json['marker'] as int?,
      lastaccess: json['lastaccess'] as int?,
      isfavourite: json['isfavourite'] as bool?,
      hidden: json['hidden'] as bool?,
      showactivitydates: json['showactivitydates'] as bool?,
      showcompletionconditions: json['showcompletionconditions'] as bool?,
    );

Map<String, dynamic> _$CourseToJson(Course instance) => <String, dynamic>{
      'id': instance.id,
      'shortname': instance.shortname,
      'fullname': instance.fullname,
      'displayname': instance.displayname,
      'enrolledusercount': instance.enrolledusercount,
      'idnumber': instance.idnumber,
      'visible': instance.visible,
      'summary': instance.summary,
      'summaryformat': instance.summaryformat,
      'format': instance.format,
      'showgrades': instance.showgrades,
      'lang': instance.lang,
      'enablecompletion': instance.enablecompletion,
      'completionhascriteria': instance.completionhascriteria,
      'completionusertracked': instance.completionusertracked,
      'category': instance.category,
      'progress': instance.progress,
      'completed': instance.completed,
      'startdate': instance.startdate,
      'enddate': instance.enddate,
      'marker': instance.marker,
      'lastaccess': instance.lastaccess,
      'isfavourite': instance.isfavourite,
      'hidden': instance.hidden,
      'showactivitydates': instance.showactivitydates,
      'showcompletionconditions': instance.showcompletionconditions,
    };
