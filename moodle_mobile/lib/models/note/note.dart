import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  }) : assert((title ?? '').isNotEmpty || (content ?? '').isNotEmpty);

  DateTime get creationDate =>
      DateTime.fromMillisecondsSinceEpoch(int.tryParse(id.split('_')[1]) ?? 0);

  bool get isPersonal => courseId == null;

  bool get isNotDone => !isDone;

  String getCourseName(BuildContext context) {
    if (isPersonal) {
      return AppLocalizations.of(context)!.personal;
    }
    return '$courseId';
  }

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);

  Map<String, dynamic> toJson() => _$NoteToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}