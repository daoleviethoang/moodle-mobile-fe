// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assignment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Assignment _$AssignmentFromJson(Map<String, dynamic> json) => Assignment(
      id: json['id'] as int?,
      cmid: json['cmid'] as int?,
      course: json['course'] as int?,
      name: json['name'] as String?,
      nosubmissions: json['nosubmissions'] as int?,
      submissiondrafts: json['submissiondrafts'] as int?,
      sendnotifications: json['sendnotifications'] as int?,
      sendlatenotifications: json['sendlatenotifications'] as int?,
      sendstudentnotifications: json['sendstudentnotifications'] as int?,
      duedate: json['duedate'] as int?,
      allowsubmissionsfromdate: json['allowsubmissionsfromdate'] as int?,
      grade: json['grade'] as int?,
      timemodified: json['timemodified'] as int?,
      completionsubmit: json['completionsubmit'] as int?,
      cutoffdate: json['cutoffdate'] as int?,
      gradingduedate: json['gradingduedate'] as int?,
      teamsubmission: json['teamsubmission'] as int?,
      requireallteammemberssubmit: json['requireallteammemberssubmit'] as int?,
      teamsubmissiongroupingid: json['teamsubmissiongroupingid'] as int?,
      blindmarking: json['blindmarking'] as int?,
      hidegrader: json['hidegrader'] as int?,
      revealidentities: json['revealidentities'] as int?,
      attemptreopenmethod: json['attemptreopenmethod'] as String?,
      maxattempts: json['maxattempts'] as int?,
      markingworkflow: json['markingworkflow'] as int?,
      markingallocation: json['markingallocation'] as int?,
      requiresubmissionstatement: json['requiresubmissionstatement'] as int?,
      preventsubmissionnotingroup: json['preventsubmissionnotingroup'] as int?,
      configs: (json['configs'] as List<dynamic>?)
          ?.map((e) => ConfigsAssignment.fromJson(e as Map<String, dynamic>))
          .toList(),
      intro: json['intro'] as String?,
      introformat: json['introformat'] as int?,
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
