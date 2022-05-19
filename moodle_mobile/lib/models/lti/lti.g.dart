// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lti.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lti _$LtiFromJson(Map<String, dynamic> json) => Lti(
      endpoint: json['endpoint'] as String?,
      parameters: (json['parameters'] as List<dynamic>?)
          ?.map((e) => Parameter.fromJson(e as Map<String, dynamic>))
          .toList(),
      warnings: (json['warnings'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
    );

Map<String, dynamic> _$LtiToJson(Lti instance) => <String, dynamic>{
      'endpoint': instance.endpoint,
      'parameters': instance.parameters,
      'warnings': instance.warnings,
    };
