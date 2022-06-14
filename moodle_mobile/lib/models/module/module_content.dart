import 'package:json_annotation/json_annotation.dart';

part 'module_content.g.dart';

@JsonSerializable()
class ModuleContent {
  String? type;
  String? filename;
  String? filepath;
  int? filesize;
  String? fileurl;
  int? timecreated;
  int? timemodified;
  int? sortorder;
  int? userid;
  String? mimetype;
  String? author;
  String? license;

  ModuleContent({
    this.type,
    this.filename,
    this.filepath,
    this.filesize,
    this.fileurl,
    this.timecreated,
    this.timemodified,
    this.sortorder,
    this.userid,
    this.mimetype,
    this.author,
    this.license,
  });

  factory ModuleContent.fromJson(Map<String, dynamic> json) =>
      _$ModuleContentFromJson(json);
  Map<String, dynamic> toJson() => _$ModuleContentToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
