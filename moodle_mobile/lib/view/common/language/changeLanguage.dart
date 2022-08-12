import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SetListLangTiles extends StatefulWidget {
  String language = "default";
  SetListLangTiles({Key? key, required this.language}) : super(key: key);

  @override
  _SetListLangTilesState createState() => _SetListLangTilesState();
}

class _SetListLangTilesState extends State<SetListLangTiles> {
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(AppLocalizations.of(context)!.default_language),
          onTap: () {
            setState(() {
              widget.language = "default";
            });
          },
          leading: widget.language == "default"
              ? const Icon(Icons.check_circle)
              : const Icon(Icons.check),
        ),
        ListTile(
          title: Text("English"),
          onTap: () {
            setState(() {
              widget.language = "en";
            });
          },
          // ignore: unnecessary_new
          leading: widget.language == "en"
              ? const Icon(Icons.check_circle)
              : const Icon(Icons.check),
        ),
        ListTile(
          title: Text("Việt Nam"),
          onTap: () {
            setState(() {
              widget.language = "vi";
            });
          },
          leading: widget.language == "vi"
              ? const Icon(Icons.check_circle)
              : const Icon(Icons.check),
        ),
      ],
    );
  }
}
