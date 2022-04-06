import 'package:json_annotation/json_annotation.dart';
import 'package:moodle_mobile/models/assignment/config.dart';

part 'assignment.g.dart';

@JsonSerializable()
class Assignment {
  int? id;
  int? cmid;
  int? course;
  String? name;
  int? nosubmissions;
  int? submissiondrafts;
  int? sendnotifications;
  int? sendlatenotifications;
  int? sendstudentnotifications;
  int? duedate;
  int? allowsubmissionsfromdate;
  int? grade;
  int? timemodified;
  int? completionsubmit;
  int? cutoffdate;
  int? gradingduedate;
  int? teamsubmission;
  int? requireallteammemberssubmit;
  int? teamsubmissiongroupingid;
  int? blindmarking;
  int? hidegrader;
  int? revealidentities;
  String? attemptreopenmethod;
  int? maxattempts;
  int? markingworkflow;
  int? markingallocation;
  int? requiresubmissionstatement;
  int? preventsubmissionnotingroup;
  @JsonKey(nullable: true)
  List<ConfigsAssignment>? configs;
  String? intro;
  int? introformat;

  Assignment({
    this.id,
    this.cmid,
    this.course,
    this.name,
    this.nosubmissions,
    this.submissiondrafts,
    this.sendnotifications,
    this.sendlatenotifications,
    this.sendstudentnotifications,
    this.duedate,
    this.allowsubmissionsfromdate,
    this.grade,
    this.timemodified,
    this.completionsubmit,
    this.cutoffdate,
    this.gradingduedate,
    this.teamsubmission,
    this.requireallteammemberssubmit,
    this.teamsubmissiongroupingid,
    this.blindmarking,
    this.hidegrader,
    this.revealidentities,
    this.attemptreopenmethod,
    this.maxattempts,
    this.markingworkflow,
    this.markingallocation,
    this.requiresubmissionstatement,
    this.preventsubmissionnotingroup,
    this.configs,
    this.intro,
    this.introformat,
  });
  factory Assignment.fromJson(Map<String, dynamic> json) =>
      _$AssignmentFromJson(json);
  Map<String, dynamic> toJson() => _$AssignmentToJson(this);
}
