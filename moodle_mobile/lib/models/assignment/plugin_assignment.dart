// ignore_for_file: unnecessary_this

import 'package:moodle_mobile/models/assignment/filearea_assignment.dart';

class Plugins {
  String? type;
  String? name;
  List<Fileareas>? fileareas;

  Plugins({this.type, this.name, this.fileareas});

  Plugins.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    name = json['name'];
    if (json['fileareas'] != null) {
      fileareas = [];
      json['fileareas'].forEach((v) {
        fileareas!.add(Fileareas.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = type;
    data['name'] = name;
    if (this.fileareas != null) {
      data['fileareas'] = fileareas!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
