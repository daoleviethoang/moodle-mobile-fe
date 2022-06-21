import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'note.g.dart';

@JsonSerializable()
class Note {
  final String id;
  final int? courseId;
  final String? title;
  final String? content;
  final bool isDone;
  final bool isImportant;

  DateTime get creationDate =>
      DateTime.fromMillisecondsSinceEpoch(int.tryParse(id.split('_')[1]) ?? 0);

  bool get isNotDone => !isDone;

  String getCourseName(BuildContext context) {
    if (courseId == null) {
      return AppLocalizations.of(context)!.personal;
    }
    return '$courseId';
  }

  Note({
    required this.id,
    required this.courseId,
    required this.title,
    this.content,
    this.isDone = false,
    this.isImportant = false,
  }) : assert((title ?? '').isNotEmpty || (content ?? '').isNotEmpty);

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);

  Map<String, dynamic> toJson() => _$NoteToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}