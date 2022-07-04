import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum NoteFolderType {
  all,
  important,
  done,
  other,
  recent,
}

class NoteFolder extends StatefulWidget {
  final NoteFolderType type;

  const NoteFolder({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  _NoteFolderState createState() => _NoteFolderState();
}

class _NoteFolderState extends State<NoteFolder> {
  late NoteFolderType _type;

  Widget _body = Container();

  @override
  void initState() {
    super.initState();
    _type = widget.type;
  }

  void _initBody() {
    _body = Container();
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