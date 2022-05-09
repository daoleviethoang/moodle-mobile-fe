// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'week.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Week _$WeekFromJson(Map<String, dynamic> json) => Week(
      prepadding:
          (json['prepadding'] as List<dynamic>?)?.map((e) => e as int).toList(),
      postpadding: (json['postpadding'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      days: (json['days'] as List<dynamic>?)
          ?.map((e) => Day.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WeekToJson(Week instance) => <String, dynamic>{
      'prepadding': instance.prepadding,
      'postpadding': instance.postpadding,
      'days': instance.days,
    };
