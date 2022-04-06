import 'package:json_annotation/json_annotation.dart';
import 'package:moodle_mobile/models/assignment/config.dart';

part 'assignment.g.dart';

@JsonSerializable()
class Assignment {
  int id;
  int cmid;
  int course;
  String name;
  int nosubmissions;
  int submissiondrafts;
  int sendnotifications;
  int sendlatenotifications;
  int sendstudentnotifications;
  int duedate;
  int allowsubmissionsfromdate;
  int grade;
  int timemodified;
  int completionsubmit;
  int cutoffdate;
  int gradingduedate;
  int teamsubmission;
  int requireallteammemberssubmit;
  int teamsubmissiongroupingid;
  int blindmarking;
  int hidegrader;
  int revealidentities;
  String attemptreopenmethod;
  int maxattempts;
  int markingworkflow;
  int markingallocation;
  int requiresubmissionstatement;
  int preventsubmissionnotingroup;
  @JsonKey(nullable: true)
  List<ConfigsAssignment>? configs;
  String intro;
  int introformat;

  Assignment({
    this.id = -1,
    this.cmid = -1,
    this.course = -1,
    this.name = "",
    this.nosubmissions = -1,
    this.submissiondrafts = -1,
    this.sendnotifications = -1,
    this.sendlatenotifications = -1,
    this.sendstudentnotifications = -1,
    this.duedate = -1,
    this.allowsubmissionsfromdate = -1,
    this.grade = -1,
    this.timemodified = -1,
    this.completionsubmit = -1,
    this.cutoffdate = -1,
    this.gradingduedate = -1,
    this.teamsubmission = -1,
    this.requireallteammemberssubmit = -1,
    this.teamsubmissiongroupingid = -1,
    this.blindmarking = -1,
    this.hidegrader = -1,
    this.revealidentities = -1,
    this.attemptreopenmethod = "",
    this.maxattempts = -1,
    this.markingworkflow = -1,
    this.markingallocation = -1,
    this.requiresubmissionstatement = -1,
    this.preventsubmissionnotingroup = -1,
    this.configs,
    this.intro = "",
    this.introformat = -1,
  });
  factory Assignment.fromJson(Map<String, dynamic> json) =>
      _$AssignmentFromJson(json);
  Map<String, dynamic> toJson() => _$AssignmentToJson(this);
}
