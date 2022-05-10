// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'period.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Period _$PeriodFromJson(Map<String, dynamic> json) => Period(
      seconds: json['seconds'] as int?,
      minutes: json['minutes'] as int?,
      hours: json['hours'] as int?,
      mday: json['mday'] as int?,
      wday: json['wday'] as int?,
      mon: json['mon'] as int?,
      year: json['year'] as int?,
      yday: json['yday'] as int?,
      weekday: json['weekday'] as String?,
      month: json['month'] as String?,
      timestamp: json['timestamp'] as int?,
    );

Map<String, dynamic> _$PeriodToJson(Period instance) => <String, dynamic>{
      'seconds': instance.seconds,
      'minutes': instance.minutes,
      'hours': instance.hours,
      'mday': instance.mday,
      'wday': instance.wday,
      'mon': instance.mon,
      'year': instance.year,
      'yday': instance.yday,
      'weekday': instance.weekday,
      'month': instance.month,
      'timestamp': instance.timestamp,
    };
