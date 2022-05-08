import 'package:json_annotation/json_annotation.dart';

import 'completiondata.dart';

part 'module.g.dart';

@JsonSerializable()
class Module {
  int? id;
  String? url;
  String? name;
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

  Module({this.id,
    this.url,
    this.name,
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
    this.completiondata});

  factory Module.fromJson(Map<String, dynamic> json) =>
      _$ModuleFromJson(json);
  Map<String, dynamic> toJson() => _$ModuleToJson(this);
}