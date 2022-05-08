// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module_contents_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModuleContentsInfo _$ModuleContentsInfoFromJson(Map<String, dynamic> json) =>
    ModuleContentsInfo(
      filescount: json['filescount'] as int?,
      filessize: json['filessize'] as int?,
      lastmodified: json['lastmodified'] as int?,
      mimetypes: (json['mimetypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      repositorytype: json['repositorytype'] as String?,
    );

Map<String, dynamic> _$ModuleContentsInfoToJson(ModuleContentsInfo instance) =>
    <String, dynamic>{
      'filescount': instance.filescount,
      'filessize': instance.filessize,
      'lastmodified': instance.lastmodified,
      'mimetypes': instance.mimetypes,
      'repositorytype': instance.repositorytype,
    };
