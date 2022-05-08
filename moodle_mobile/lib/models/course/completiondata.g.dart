// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'completiondata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Completiondata _$CompletiondataFromJson(Map<String, dynamic> json) =>
    Completiondata(
      state: json['state'] as int?,
      timecompleted: json['timecompleted'] as int?,
      overrideby: json['overrideby'],
      valueused: json['valueused'] as bool?,
      hascompletion: json['hascompletion'] as bool?,
      isautomatic: json['isautomatic'] as bool?,
      istrackeduser: json['istrackeduser'] as bool?,
      uservisible: json['uservisible'] as bool?,
      details: json['details'] as List<dynamic>?,
    );

Map<String, dynamic> _$CompletiondataToJson(Completiondata instance) =>
    <String, dynamic>{
      'state': instance.state,
      'timecompleted': instance.timecompleted,
      'overrideby': instance.overrideby,
      'valueused': instance.valueused,
      'hascompletion': instance.hascompletion,
      'isautomatic': instance.isautomatic,
      'istrackeduser': instance.istrackeduser,
      'uservisible': instance.uservisible,
      'details': instance.details,
    };
