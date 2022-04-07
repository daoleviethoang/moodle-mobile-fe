import 'package:moodle_mobile/models/assignment/files_assignment.dart';

class Fileareas {
  String? area;
  List<Files>? files;

  Fileareas({this.area, this.files});

  Fileareas.fromJson(Map<String, dynamic> json) {
    area = json['area'];
    if (json['files'] != null) {
      files = [];
      json['files'].forEach((v) {
        files!.add(Files.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['area'] = area;
    if (this.files != null) {
      data['files'] = files!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
