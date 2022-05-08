import 'package:json_annotation/json_annotation.dart';

part 'module_contents_info.g.dart';

@JsonSerializable()
class ModuleContentsInfo {
  int? filescount;
  int? filessize;
  int? lastmodified;
  List<String>? mimetypes;
  String? repositorytype;

  ModuleContentsInfo({
    this.filescount,
    this.filessize,
    this.lastmodified,
    this.mimetypes,
    this.repositorytype,
  });

  factory ModuleContentsInfo.fromJson(Map<String, dynamic> json) =>
      _$ModuleContentsInfoFromJson(json);
  Map<String, dynamic> toJson() => _$ModuleContentsInfoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}