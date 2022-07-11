import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:moodle_mobile/constants/vars.dart';
import 'package:moodle_mobile/data/network/apis/course/course_detail_service.dart';
import 'package:moodle_mobile/data/network/apis/notes/notes_service.dart';

part 'note.g.dart';

@JsonSerializable()
class Note {
  static String doneChar = '✔';
  static String importantChar = '⭐';

  /// Returns `noteid` or `id` if either is not null
  @JsonKey(ignore: true)
  // ignore: deprecated_member_use_from_same_package
  int get nid => noteid ?? id ?? -1;

  /// Returns text or content if either is not null.<br/>
  /// If txt has a `doneChar` at the beginning, it `isDone`.<br/>
  /// If txt has an `importantChar` at the beginning, it `isImportant`.<br/>
  /// If the note both `isDone` and `isImportant`, it has the following format:
  /// `$doneChar $importantChar $txtFiltered`
  @JsonKey(ignore: true)
  // ignore: deprecated_member_use_from_same_package
  String get txt => text ?? content ?? '';

  /// Returns `text` or `content` if either is not null,
  /// filtering out `doneChar` and `importantChar` if present
  @JsonKey(ignore: true)
  String get txtFiltered {
    var _txt = txt;
    if (isDone) {
      _txt = _txt.replaceFirst(doneChar, '').trimLeft();
    }
    if (isImportant) {
      _txt = _txt.replaceFirst(importantChar, '').trimLeft();
    }
    return _txt;
  }

  /// Returns pure text from txt (by striping all HTML tags)
  String get txtFormatted => Bidi.stripHtmlIfNeeded(txtFiltered);

  @Deprecated('use nid instead')
  int? noteid;

  int? userid;

  /// 'personal', 'course' or 'site'
  /// Or note state (i.e. draft, public, site)
  String? publishstate;

  int? courseid;

  @Deprecated('use txt instead')
  String? text;

  /// (1 = HTML, 0 = MOODLE, 2 = PLAIN or 4 = MARKDOWN)
  int? format;

  // Only in core_notes_get_course_notes
  @Deprecated('use nid instead')
  int? id;

  @Deprecated('use txt instead')
  String? content;

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

  /// Change text or content depending on which is not null. <br/>
  /// Must include `doneChar` and/or `importantChar` when either/both is true
  /// or else their status will be lost. <br/>
  /// That requirement is not needed if you use `txtFiltered` setter instead.
  set txt(String value) {
    // ignore: deprecated_member_use_from_same_package
    if (text != null) {
      // ignore: deprecated_member_use_from_same_package
      text = value;
    }
    // ignore: deprecated_member_use_from_same_package
    if (content != null) {
      // ignore: deprecated_member_use_from_same_package
      content = value;
    }
  }

  /// Change text or content depending on which is not null,
  /// also preserves isDone and isImportant status
  set txtFiltered(String value) {
    value = '${isDone ? '$doneChar ' : ''}'
        '${isImportant ? '$importantChar ' : ''}'
        '$value';
    // ignore: deprecated_member_use_from_same_package
    if (text != null) {
      // ignore: deprecated_member_use_from_same_package
      text = value;
    }
    // ignore: deprecated_member_use_from_same_package
    if (content != null) {
      // ignore: deprecated_member_use_from_same_package
      content = value;
    }
  }

  @JsonKey(ignore: true)
  bool get isDone => txt.startsWith(doneChar);

  bool get isNotDone => !isDone;

  set isDone(bool done) {
    if (isDone == done) {
      return;
    } else {
      txt = '${done ? '$doneChar ' : ''}'
          '${isImportant ? '$importantChar ' : ''}'
          '$txtFiltered';
    }
  }

  @JsonKey(ignore: true)
  bool get isImportant =>
      txt.startsWith('${isDone ? '$doneChar ' : ''}$importantChar');

  bool get isNotImportant => !isImportant;

  set isImportant(bool important) {
    if (isImportant == important) {
      return;
    } else {
      txt = '${isDone ? '$doneChar ' : ''}'
          '${important ? '$importantChar ' : ''}'
          '$txtFiltered';
    }
  }

  DateTime? get creationDate {
    if (created == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(created! * 1000);
  }

  bool get isEmpty => txt.isEmpty;

  bool get isNotEmpty => !isEmpty;

  bool get isRecent {
    if (creationDate == null) return false;
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

  Future<Note?> refreshData(String token) async {
    final notes = await NotesService().getCourseNotes(token, courseid!);
    final newNote = notes.getById(nid);
    if (newNote != null) {
      txt = newNote.txt;
      return this;
    }
    return null;
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
          nid == other.nid &&
          userid == other.userid &&
          courseid == other.courseid &&
          txt == other.txt;

  @override
  int get hashCode => toJson().hashCode;
}