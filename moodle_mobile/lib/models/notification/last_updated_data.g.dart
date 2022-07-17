// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'last_updated_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LastUpdateData _$LastUpdateDataFromJson(Map<String, dynamic> json) =>
    LastUpdateData(
      messages: (json['messages'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(int.parse(k), e as String),
      ),
      events: (json['events'] as List<dynamic>?)?.map((e) => e as int).toList(),
      notifications: (json['notifications'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
    );

Map<String, dynamic> _$LastUpdateDataToJson(LastUpdateData instance) =>
    <String, dynamic>{
      'messages': instance.messages.map((k, e) => MapEntry(k.toString(), e)),
      'events': instance.events,
      'notifications': instance.notifications,
    };
