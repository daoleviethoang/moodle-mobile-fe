import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moodle_mobile/models/note/note.dart';
import 'package:moodle_mobile/models/note/notes.dart';
import 'package:moodle_mobile/view/common/content_item.dart';
import 'package:moodle_mobile/view/common/data_card.dart';

enum NoteFolderType {
  all,
  important,
  done,
  other,
  recent,
}

class NoteFolder extends StatefulWidget {
  final Notes notes;
  final NoteFolderType type;
  final String token;
  final Function(bool, Note)? onCheckbox;
  final Function(Note)? onPressed;
  final Function(Note)? onDelete;

  const NoteFolder({
    Key? key,
    required this.notes,
    required this.type,
    required this.token,
    this.onCheckbox,
    this.onPressed,
    this.onDelete,
  }) : super(key: key);

  @override
  _NoteFolderState createState() => _NoteFolderState();
}

class _NoteFolderState extends State<NoteFolder> {
  late Map<int?, List<Note>> _notes;
  late NoteFolderType _type;

  Widget _body = Container();

  @override
  void initState() {
    super.initState();
    _type = widget.type;
    switch (_type) {
      case NoteFolderType.all:
        _notes = widget.notes.byCourse;
        break;
      case NoteFolderType.important:
        _notes = {null: widget.notes.important};
        break;
      case NoteFolderType.done:
        _notes = {null: widget.notes.done};
        break;
      case NoteFolderType.other:
        _notes = {null: widget.notes.other};
        break;
      case NoteFolderType.recent:
        _notes = {null: widget.notes.recent};
        break;
    }
  }

  void _initBody() {
    _body = ListView(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      children: [
        Container(height: 8),
        // TODO: Search box
        const LoadingCard(text: 'Search box puts here'),
        Container(height: 12),
        ..._notes.keys.map((cid) {
          return SectionItem(
            header: cid == null
                ? null
                : FutureBuilder(
              future: _notes[cid]!.first.getCourseName(context, widget.token),
              builder: (context, snapshot) {
                String courseName = '…';
                if (snapshot.hasData) {
                  courseName = snapshot.data as String;
                } else if (snapshot.hasError) {
                  if (kDebugMode) print(snapshot.error);
                  return Container();
                }
                return HeaderItem(text: courseName);
              },
            ),
            body: _notes[cid]?.map((n) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: NoteCard(
                  n,
                  widget.token,
                  onCheckbox: widget.onCheckbox == null
                      ? null
                      : (value) => widget.onCheckbox!(value, n),
                  onPressed: widget.onPressed == null
                      ? null
                      : () => widget.onPressed!(n),
                  onDelete: widget.onDelete == null
                      ? null
                      : () => widget.onDelete!(n),
                ),
              );
            }).toList(),
          );
        })
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _initBody();

    return Scaffold(
      appBar: AppBar(
        title: Builder(builder: (context) {
          switch (_type) {
            case NoteFolderType.all:
              return Text(AppLocalizations.of(context)!.all_notes);
            case NoteFolderType.important:
              return Text(AppLocalizations.of(context)!.important);
            case NoteFolderType.done:
              return Text(AppLocalizations.of(context)!.done);
            case NoteFolderType.other:
              return Text(AppLocalizations.of(context)!.other);
            case NoteFolderType.recent:
              return Text(AppLocalizations.of(context)!.recent_notes);
          }
        }),
      ),
      body: _body,
    );
  }
}