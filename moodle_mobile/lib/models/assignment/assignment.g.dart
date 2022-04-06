// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assignment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Assignment _$AssignmentFromJson(Map<String, dynamic> json) => Assignment(
      id: json['id'] as int? ?? -1,
      cmid: json['cmid'] as int? ?? -1,
      course: json['course'] as int? ?? -1,
      name: json['name'] as String? ?? "",
      nosubmissions: json['nosubmissions'] as int? ?? -1,
      submissiondrafts: json['submissiondrafts'] as int? ?? -1,
      sendnotifications: json['sendnotifications'] as int? ?? -1,
      sendlatenotifications: json['sendlatenotifications'] as int? ?? -1,
      sendstudentnotifications: json['sendstudentnotifications'] as int? ?? -1,
      duedate: json['duedate'] as int? ?? -1,
      allowsubmissionsfromdate: json['allowsubmissionsfromdate'] as int? ?? -1,
      grade: json['grade'] as int? ?? -1,
      timemodified: json['timemodified'] as int? ?? -1,
      completionsubmit: json['completionsubmit'] as int? ?? -1,
      cutoffdate: json['cutoffdate'] as int? ?? -1,
      gradingduedate: json['gradingduedate'] as int? ?? -1,
      teamsubmission: json['teamsubmission'] as int? ?? -1,
      requireallteammemberssubmit:
          json['requireallteammemberssubmit'] as int? ?? -1,
      teamsubmissiongroupingid: json['teamsubmissiongroupingid'] as int? ?? -1,
      blindmarking: json['blindmarking'] as int? ?? -1,
      hidegrader: json['hidegrader'] as int? ?? -1,
      revealidentities: json['revealidentities'] as int? ?? -1,
      attemptreopenmethod: json['attemptreopenmethod'] as String? ?? "",
      maxattempts: json['maxattempts'] as int? ?? -1,
      markingworkflow: json['markingworkflow'] as int? ?? -1,
      markingallocation: json['markingallocation'] as int? ?? -1,
      requiresubmissionstatement:
          json['requiresubmissionstatement'] as int? ?? -1,
      preventsubmissionnotingroup:
          json['preventsubmissionnotingroup'] as int? ?? -1,
      configs: (json['configs'] as List<dynamic>?)
          ?.map((e) => ConfigsAssignment.fromJson(e as Map<String, dynamic>))
          .toList(),
      intro: json['intro'] as String? ?? "",
      introformat: json['introformat'] as int? ?? -1,
    );

Map<String, dynamic> _$AssignmentToJson(Assignment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cmid': instance.cmid,
      'course': instance.course,
      'name': instance.name,
      'nosubmissions': instance.nosubmissions,
      'submissiondrafts': instance.submissiondrafts,
      'sendnotifications': instance.sendnotifications,
      'sendlatenotifications': instance.sendlatenotifications,
      'sendstudentnotifications': instance.sendstudentnotifications,
      'duedate': instance.duedate,
      'allowsubmissionsfromdate': instance.allowsubmissionsfromdate,
      'grade': instance.grade,
      'timemodified': instance.timemodified,
      'completionsubmit': instance.completionsubmit,
      'cutoffdate': instance.cutoffdate,
      'gradingduedate': instance.gradingduedate,
      'teamsubmission': instance.teamsubmission,
      'requireallteammemberssubmit': instance.requireallteammemberssubmit,
      'teamsubmissiongroupingid': instance.teamsubmissiongroupingid,
      'blindmarking': instance.blindmarking,
      'hidegrader': instance.hidegrader,
      'revealidentities': instance.revealidentities,
      'attemptreopenmethod': instance.attemptreopenmethod,
      'maxattempts': instance.maxattempts,
      'markingworkflow': instance.markingworkflow,
      'markingallocation': instance.markingallocation,
      'requiresubmissionstatement': instance.requiresubmissionstatement,
      'preventsubmissionnotingroup': instance.preventsubmissionnotingroup,
      'configs': instance.configs,
      'intro': instance.intro,
      'introformat': instance.introformat,
    };
