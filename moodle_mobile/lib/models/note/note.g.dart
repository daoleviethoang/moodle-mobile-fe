// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Note _$NoteFromJson(Map<String, dynamic> json) => Note(
      id: json['id'] as String,
      courseId: json['courseId'] as int?,
      title: json['title'] as String?,
      content: json['content'] as String?,
      isDone: json['isDone'] as bool? ?? false,
      isImportant: json['isImportant'] as bool? ?? false,
    );

Map<String, dynamic> _$NoteToJson(Note instance) => <String, dynamic>{
      'id': instance.id,
      'courseId': instance.courseId,
      'title': instance.title,
      'content': instance.content,
      'isDone': instance.isDone,
      'isImportant': instance.isImportant,
    };
