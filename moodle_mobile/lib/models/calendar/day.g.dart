// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Day _$DayFromJson(Map<String, dynamic> json) => Day(
      seconds: json['seconds'] as int?,
      minutes: json['minutes'] as int?,
      hours: json['hours'] as int?,
      mday: json['mday'] as int?,
      wday: json['wday'] as int?,
      year: json['year'] as int?,
      yday: json['yday'] as int?,
      istoday: json['istoday'] as bool?,
      isweekend: json['isweekend'] as bool?,
      timestamp: json['timestamp'] as int?,
      neweventtimestamp: json['neweventtimestamp'] as int?,
      viewdaylink: json['viewdaylink'] as String?,
      events: (json['events'] as List<dynamic>?)
          ?.map((e) => Event.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasevents: json['hasevents'] as bool?,
      calendareventtypes: (json['calendareventtypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      previousperiod: json['previousperiod'] as int?,
      nextperiod: json['nextperiod'] as int?,
      navigation: json['navigation'] as String?,
      haslastdayofevent: json['haslastdayofevent'] as bool?,
      popovertitle: json['popovertitle'] as String?,
      daytitle: json['daytitle'] as String?,
      viewdaylinktitle: json['viewdaylinktitle'] as String?,
    );

Map<String, dynamic> _$DayToJson(Day instance) => <String, dynamic>{
      'seconds': instance.seconds,
      'minutes': instance.minutes,
      'hours': instance.hours,
      'mday': instance.mday,
      'wday': instance.wday,
      'year': instance.year,
      'yday': instance.yday,
      'istoday': instance.istoday,
      'isweekend': instance.isweekend,
      'timestamp': instance.timestamp,
      'neweventtimestamp': instance.neweventtimestamp,
      'viewdaylink': instance.viewdaylink,
      'events': instance.events,
      'hasevents': instance.hasevents,
      'calendareventtypes': instance.calendareventtypes,
      'previousperiod': instance.previousperiod,
      'nextperiod': instance.nextperiod,
      'navigation': instance.navigation,
      'haslastdayofevent': instance.haslastdayofevent,
      'popovertitle': instance.popovertitle,
      'daytitle': instance.daytitle,
      'viewdaylinktitle': instance.viewdaylinktitle,
    };

DayName _$DayNameFromJson(Map<String, dynamic> json) => DayName(
      dayno: json['dayno'] as int?,
      shortname: json['shortname'] as String?,
      fullname: json['fullname'] as String?,
    );

Map<String, dynamic> _$DayNameToJson(DayName instance) => <String, dynamic>{
      'dayno': instance.dayno,
      'shortname': instance.shortname,
      'fullname': instance.fullname,
    };
