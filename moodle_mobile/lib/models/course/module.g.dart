// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Module _$ModuleFromJson(Map<String, dynamic> json) => Module(
      id: json['id'] as int?,
      url: json['url'] as String?,
      name: json['name'] as String?,
      instance: json['instance'] as int?,
      contextid: json['contextid'] as int?,
      visible: json['visible'] as int?,
      uservisible: json['uservisible'] as bool?,
      visibleoncoursepage: json['visibleoncoursepage'] as int?,
      modicon: json['modicon'] as String?,
      modname: json['modname'] as String?,
      modplural: json['modplural'] as String?,
      indent: json['indent'] as int?,
      onclick: json['onclick'] as String?,
      afterlink: json['afterlink'],
      customdata: json['customdata'] as String?,
      noviewlink: json['noviewlink'] as bool?,
      completion: json['completion'] as int?,
      dates: json['dates'] as List<dynamic>?,
      completiondata: json['completiondata'] == null
          ? null
          : Completiondata.fromJson(
              json['completiondata'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ModuleToJson(Module instance) => <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'name': instance.name,
      'instance': instance.instance,
      'contextid': instance.contextid,
      'visible': instance.visible,
      'uservisible': instance.uservisible,
      'visibleoncoursepage': instance.visibleoncoursepage,
      'modicon': instance.modicon,
      'modname': instance.modname,
      'modplural': instance.modplural,
      'indent': instance.indent,
      'onclick': instance.onclick,
      'afterlink': instance.afterlink,
      'customdata': instance.customdata,
      'noviewlink': instance.noviewlink,
      'completion': instance.completion,
      'dates': instance.dates,
      'completiondata': instance.completiondata,
    };
