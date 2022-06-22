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
          leading: Radio<String>(
              value: "default",
              groupValue: widget.language,
              onChanged: (val) {
                setState(() {
                  widget.language = val!;
                });
              }),
        ),
        ListTile(
          title: Text("English"),
          // ignore: unnecessary_new
          leading: new Radio<String>(
              value: "en",
              groupValue: widget.language,
              onChanged: (val) {
                setState(() {
                  widget.language = val!;
                });
              }),
        ),
        ListTile(
          title: Text("Việt Nam"),
          leading: Radio<String>(
              value: "vi",
              groupValue: widget.language,
              onChanged: (val) {
                setState(() {
                  widget.language = val!;
                });
              }),
        ),
      ],
    );
  }
}
