import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moodle_mobile/constants/vars.dart';
import 'package:moodle_mobile/data/network/apis/course/course_detail_service.dart';

part 'note.g.dart';

@JsonSerializable()
class Note {
  static String doneChar = '✔';
  static String importantChar = '⭐';

  /// Don't use text or content, use this instead
  @JsonKey(ignore: true)
  String get txt => text ?? content ?? '';

  /// Or this if the doneChar and importantChar are not needed
  String get txtFiltered {
    var _txt = txt;
    if (isDone) {
      _txt = _txt.replaceFirst(doneChar, '');
    }
    if (isImportant) {
      _txt = _txt.replaceFirst(importantChar, '');
    }
    return _txt;
  }

  int? noteid;
  int? userid;
  String? publishstate; // 'personal', 'course' or 'site'
  // Or note state (i.e. draft, public, site)
  int? courseid;
  String? text; // DONT USE THIS, use txt instead
  int? format; // (1 = HTML, 0 = MOODLE, 2 = PLAIN or 4 = MARKDOWN)

  // Only in core_notes_get_course_notes
  String? content; // DONT USE THIS, use txt instead
  int? created;
  int? lastmodified;
  int? usermodified;

  // Only in core_notes_create_notes
  String? clientnoteid;

  // Additional fields
  @JsonKey(ignore: true)
  String? courseName;

  Note({
    this.noteid,
    this.userid,
    this.publishstate,
    this.courseid,
    this.text,
    this.format,
    this.content,
    this.created,
    this.lastmodified,
    this.usermodified,
    this.clientnoteid,
  });

  /// Change text or content depending on which is not null
  set txt(String value) {
    if (text != null) {
      text = value;
    }
    if (content != null) {
      content = value;
    }
  }

  bool get isDone => txt.startsWith(doneChar);

  bool get isNotDone => !isDone;

  @JsonKey(ignore: true)
  bool get isImportant => txt.startsWith(importantChar);

  bool get isNotImportant => !isImportant;

  set isImportant(bool important) {
    if (isImportant) {
      if (important) {
        return; // Already important
      } else {
        txt = txt.substring(1);
      }
    } else {
      if (important) {
        txt = importantChar + txt.substring(1);
      } else {
        return; // Already not important
      }
    }
  }

  DateTime? get creationDate {
    if (created == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(created!);
  }

  bool get isEmpty => txt.isEmpty;

  bool get isNotEmpty => !isEmpty;

  bool get isRecent {
    if (created == null) return false;
    return DateTime.now().difference(creationDate!) < Vars.recentThreshold;
  }

  Future<String> getCourseName(BuildContext context, String token) async {
    if (courseName == null) {
      final course =
          await CourseDetailService().getCourseById(token, courseid ?? -1);
      courseName = course.displayname ??
          course.shortname ??
          course.fullname ??
          '$courseid';
    }
    return courseName!;
  }

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);

  Map<String, dynamic> toJson() => _$NoteToJson(this);

  @override
  String toString() => toJson().toString();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Note &&
          runtimeType == other.runtimeType &&
          noteid == other.noteid &&
          userid == other.userid &&
          courseid == other.courseid &&
          txt == other.txt;

  @override
  int get hashCode => toJson().hashCode;
}