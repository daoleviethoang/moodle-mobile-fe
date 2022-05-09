// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModuleContent _$ModuleContentFromJson(Map<String, dynamic> json) =>
    ModuleContent(
      type: json['type'] as String?,
      filename: json['filename'] as String?,
      filepath: json['filepath'] as String?,
      filesize: json['filesize'] as int?,
      fileurl: json['fileurl'] as String?,
      timecreated: json['timecreated'] as int?,
      timemodified: json['timemodified'] as int?,
      sortorder: json['sortorder'] as int?,
      userid: json['userid'] as int?,
      author: json['author'] as String?,
      license: json['license'] as String?,
    );

Map<String, dynamic> _$ModuleContentToJson(ModuleContent instance) =>
    <String, dynamic>{
      'type': instance.type,
      'filename': instance.filename,
      'filepath': instance.filepath,
      'filesize': instance.filesize,
      'fileurl': instance.fileurl,
      'timecreated': instance.timecreated,
      'timemodified': instance.timemodified,
      'sortorder': instance.sortorder,
      'userid': instance.userid,
      'author': instance.author,
      'license': instance.license,
    };
