import 'package:json_annotation/json_annotation.dart';

import 'completiondata.dart';
import 'module_content.dart';
import 'module_contents_info.dart';

part 'module.g.dart';

class ModuleName {
  static const String assign = 'assign';
  static const String chat = 'chat';
  static const String folder = 'folder';
  static const String forum = 'forum';
  static const String label = 'label';
  static const String lti = 'lti';
  static const String page = 'page';
  static const String quiz = 'quiz';
  static const String resource = 'resource';
  static const String url = 'url';
  static const String zoom = 'zoom';
}

@JsonSerializable()
class Module {
  int? id;
  String? url;
  String? name;
  String? description;
  int? instance;
  int? contextid;
  int? visible;
  bool? uservisible;
  int? visibleoncoursepage;
  String? modicon;
  String? modname;
  String? modplural;
  int? indent;
  String? onclick;
  dynamic afterlink;
  String? customdata;
  bool? noviewlink;
  int? completion;
  List<dynamic>? dates;
  Completiondata? completiondata;
  List<ModuleContent>? contents;
  ModuleContentsInfo? contentsInfo;

  Module({this.id,
    this.url,
    this.name,
    this.description,
    this.instance,
    this.contextid,
    this.visible,
    this.uservisible,
    this.visibleoncoursepage,
    this.modicon,
    this.modname,
    this.modplural,
    this.indent,
    this.onclick,
    this.afterlink,
    this.customdata,
    this.noviewlink,
    this.completion,
    this.dates,
    this.completiondata,
    this.contents,
    this.contentsInfo,
  });

  factory Module.fromJson(Map<String, dynamic> json) =>
      _$ModuleFromJson(json);
  Map<String, dynamic> toJson() => _$ModuleToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}