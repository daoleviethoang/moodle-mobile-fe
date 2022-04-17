import 'package:moodle_mobile/models/assignment/plugin_assignment.dart';

class Submission {
  int? id;
  int? userid;
  int? attemptnumber;
  int? timecreated;
  int? timemodified;
  String? status;
  int? groupid;
  int? assignment;
  int? latest;
  List<Plugins>? plugins;

  Submission(
      {this.id,
      this.userid,
      this.attemptnumber,
      this.timecreated,
      this.timemodified,
      this.status,
      this.groupid,
      this.assignment,
      this.latest,
      this.plugins});

  Submission.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    attemptnumber = json['attemptnumber'];
    timecreated = json['timecreated'];
    timemodified = json['timemodified'];
    status = json['status'];
    groupid = json['groupid'];
    assignment = json['assignment'];
    latest = json['latest'];
    if (json['plugins'] != null) {
      plugins = [];
      json['plugins'].forEach((v) {
        plugins!.add(new Plugins.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['userid'] = userid;
    data['attemptnumber'] = attemptnumber;
    data['timecreated'] = timecreated;
    data['timemodified'] = timemodified;
    data['status'] = status;
    data['groupid'] = groupid;
    data['assignment'] = assignment;
    data['latest'] = latest;
    if (plugins != null) {
      data['plugins'] = plugins!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
