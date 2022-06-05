import 'package:flutter/material.dart';

class ForumAttachment {
  String? filename;
  String? filepath;
  int? filesize;
  String? fileurl;
  int? timemodified;
  String? mimetype;
  bool? isexternalfile;

  ForumAttachment(
      {this.filename,
      this.filepath,
      this.filesize,
      this.fileurl,
      this.timemodified,
      this.mimetype,
      this.isexternalfile});

  ForumAttachment.fromJson(Map<String, dynamic> json) {
    filename = json['filename'];
    filepath = json['filepath'];
    filesize = json['filesize'];
    fileurl = json['fileurl'];
    timemodified = json['timemodified'];
    mimetype = json['mimetype'];
    isexternalfile = json['isexternalfile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['filename'] = this.filename;
    data['filepath'] = this.filepath;
    data['filesize'] = this.filesize;
    data['fileurl'] = this.fileurl;
    data['timemodified'] = this.timemodified;
    data['mimetype'] = this.mimetype;
    data['isexternalfile'] = this.isexternalfile;
    return data;
  }
}
