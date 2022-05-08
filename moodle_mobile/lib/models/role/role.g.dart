// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Role _$RoleFromJson(Map<String, dynamic> json) => Role(
      roleid: json['roleid'] as int?,
      name: json['name'] as String?,
      shortname: json['shortname'] as String?,
      sortorder: json['sortorder'] as int?,
    );

Map<String, dynamic> _$RoleToJson(Role instance) => <String, dynamic>{
      'roleid': instance.roleid,
      'name': instance.name,
      'shortname': instance.shortname,
      'sortorder': instance.sortorder,
    };
