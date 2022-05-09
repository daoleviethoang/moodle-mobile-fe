// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Calendar _$CalendarFromJson(Map<String, dynamic> json) => Calendar(
      url: json['url'] as String?,
      courseid: json['courseid'] as int?,
      categoryid: json['categoryid'] as int?,
      filterSelector: json['filterSelector'] as String?,
      weeks: (json['weeks'] as List<dynamic>?)
          ?.map((e) => Week.fromJson(e as Map<String, dynamic>))
          .toList(),
      daynames: (json['daynames'] as List<dynamic>?)
          ?.map((e) => DayName.fromJson(e as Map<String, dynamic>))
          .toList(),
      view: json['view'] as String?,
      date: json['date'] == null
          ? null
          : Period.fromJson(json['date'] as Map<String, dynamic>),
      periodname: json['periodname'] as String?,
      includenavigation: json['includenavigation'] as bool?,
      initialeventsloaded: json['initialeventsloaded'] as bool?,
      previousperiod: json['previousperiod'] == null
          ? null
          : Period.fromJson(json['previousperiod'] as Map<String, dynamic>),
      previousperiodlink: json['previousperiodlink'] as String?,
      previousperiodname: json['previousperiodname'] as String?,
      nextperiod: json['nextperiod'] == null
          ? null
          : Period.fromJson(json['nextperiod'] as Map<String, dynamic>),
      nextperiodname: json['nextperiodname'] as String?,
      nextperiodlink: json['nextperiodlink'] as String?,
      larrow: json['larrow'] as String?,
      rarrow: json['rarrow'] as String?,
      defaulteventcontext: json['defaulteventcontext'] as int?,
    );

Map<String, dynamic> _$CalendarToJson(Calendar instance) => <String, dynamic>{
      'url': instance.url,
      'courseid': instance.courseid,
      'categoryid': instance.categoryid,
      'filterSelector': instance.filterSelector,
      'weeks': instance.weeks,
      'daynames': instance.daynames,
      'view': instance.view,
      'date': instance.date,
      'periodname': instance.periodname,
      'includenavigation': instance.includenavigation,
      'initialeventsloaded': instance.initialeventsloaded,
      'previousperiod': instance.previousperiod,
      'previousperiodlink': instance.previousperiodlink,
      'previousperiodname': instance.previousperiodname,
      'nextperiod': instance.nextperiod,
      'nextperiodname': instance.nextperiodname,
      'nextperiodlink': instance.nextperiodlink,
      'larrow': instance.larrow,
      'rarrow': instance.rarrow,
      'defaulteventcontext': instance.defaulteventcontext,
    };

CalendarIcon _$CalendarIconFromJson(Map<String, dynamic> json) => CalendarIcon(
      key: json['key'] as String?,
      component: json['component'] as String?,
      alttext: json['alttext'] as String?,
    );

Map<String, dynamic> _$CalendarIconToJson(CalendarIcon instance) =>
    <String, dynamic>{
      'key': instance.key,
      'component': instance.component,
      'alttext': instance.alttext,
    };
