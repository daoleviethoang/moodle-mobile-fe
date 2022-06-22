import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moodle_mobile/constants/vars.dart';

part 'note.g.dart';

/// A note that can be created by the user
///
/// Arguments:
///   - id: The identifier, format as follows <userId>_<creationDateTimestamp>
///   - courseId: The course this note is associated to,
///               classified as Personal if null
///   - title: Title of the note
///   - content: Html content of the note
///   - isDone: Whether the task written in this note is completed
///   - isImportant: Whether this note is important
@JsonSerializable()
class Note {
  final String id;
  final int? courseId;
  final String? title;
  final String? content;
  final bool isDone;
  final bool isImportant;

  Note({
    required this.id,
    required this.courseId,
    required this.title,
    this.content,
    this.isDone = false,
    this.isImportant = false,
  });

  DateTime get creationDate =>
      DateTime.fromMillisecondsSinceEpoch(int.tryParse(id.split('_')[1]) ?? 0);

  bool get isEmpty => (title ?? '').isEmpty && (content ?? '').isEmpty;

  bool get isRecent =>
      DateTime.now().difference(creationDate) < Vars.recentThreshold;

  bool get isPersonal => courseId == null;

  bool get isNotDone => !isDone;

  String getCourseName(BuildContext context) {
    if (isPersonal) {
      return AppLocalizations.of(context)!.personal;
    }
    return '$courseId';
  }

  factory Note.fromJson(String id, Map<String, dynamic> json) {
    json['id'] = id;
    return _$NoteFromJson(json);
  }

  Map<String, dynamic> toJson() => _$NoteToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Note &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          courseId == other.courseId &&
          title == other.title &&
          content == other.content &&
          isDone == other.isDone &&
          isImportant == other.isImportant;


  @override
  int get hashCode => toJson().hashCode;

  Note copyWith({
    String? id,
    int? courseId,
    String? title,
    String? content,
    bool? isDone,
    bool? isImportant,
  }) {
    return Note(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      content: content ?? this.content,
      isDone: isDone ?? this.isDone,
      isImportant: isImportant ?? this.isImportant,
    );
  }

}