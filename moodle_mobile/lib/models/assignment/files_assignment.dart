class Files {
  String? filename;
  String? filepath;
  int? filesize;
  String? fileurl;
  int? timemodified;
  String? mimetype;
  bool? isexternalfile;

  Files(
      {this.filename,
      this.filepath,
      this.filesize,
      this.fileurl,
      this.timemodified,
      this.mimetype,
      this.isexternalfile});

  Files.fromJson(Map<String, dynamic> json) {
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
    data['filename'] = filename;
    data['filepath'] = filepath;
    data['filesize'] = filesize;
    data['fileurl'] = fileurl;
    data['timemodified'] = timemodified;
    data['mimetype'] = mimetype;
    data['isexternalfile'] = isexternalfile;
    return data;
  }
}
