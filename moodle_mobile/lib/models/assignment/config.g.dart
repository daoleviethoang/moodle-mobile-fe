// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfigsAssignment _$ConfigsAssignmentFromJson(Map<String, dynamic> json) =>
    ConfigsAssignment(
      plugin: json['plugin'] as String? ?? "",
      subtype: json['subtype'] as String? ?? "",
      name: json['name'] as String? ?? "",
      value: json['value'] as String? ?? "",
    );

Map<String, dynamic> _$ConfigsAssignmentToJson(ConfigsAssignment instance) =>
    <String, dynamic>{
      'plugin': instance.plugin,
      'subtype': instance.subtype,
      'name': instance.name,
      'value': instance.value,
    };
