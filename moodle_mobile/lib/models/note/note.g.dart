// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Note _$NoteFromJson(Map<String, dynamic> json) => Note(
      noteid: json['noteid'] as int?,
      userid: json['userid'] as int?,
      publishstate: json['publishstate'] as String?,
      courseid: json['courseid'] as int?,
      text: json['text'] as String?,
      format: json['format'] as int?,
      content: json['content'] as String?,
      created: json['created'] as int?,
      lastmodified: json['lastmodified'] as int?,
      usermodified: json['usermodified'] as int?,
      clientnoteid: json['clientnoteid'] as String?,
    )..id = json['id'] as int?;

Map<String, dynamic> _$NoteToJson(Note instance) => <String, dynamic>{
      'noteid': instance.noteid,
      'userid': instance.userid,
      'publishstate': instance.publishstate,
      'courseid': instance.courseid,
      'text': instance.text,
      'format': instance.format,
      'id': instance.id,
      'content': instance.content,
      'created': instance.created,
      'lastmodified': instance.lastmodified,
      'usermodified': instance.usermodified,
      'clientnoteid': instance.clientnoteid,
    };
