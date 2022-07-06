import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moodle_mobile/models/note/note.dart';
import 'package:moodle_mobile/models/note/notes.dart';
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

  const NoteFolder({
    Key? key,
    required this.notes,
    required this.type,
    required this.token,
    this.onCheckbox,
    this.onPressed,
  }) : super(key: key);

  @override
  _NoteFolderState createState() => _NoteFolderState();
}

class _NoteFolderState extends State<NoteFolder> {
  late List<Note> _notes;
  late NoteFolderType _type;

  Widget _body = Container();

  @override
  void initState() {
    super.initState();
    _type = widget.type;
    switch (_type) {
      case NoteFolderType.all:
        // TODO: Group by courses
        _notes = widget.notes.importantFirst;
        break;
      case NoteFolderType.important:
        _notes = widget.notes.important;
        break;
      case NoteFolderType.done:
        _notes = widget.notes.done;
        break;
      case NoteFolderType.other:
        _notes = widget.notes.other;
        break;
      case NoteFolderType.recent:
        _notes = widget.notes.recent;
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
        ..._notes.map((n) {
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
            ),
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