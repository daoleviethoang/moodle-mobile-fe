import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moodle_mobile/constants/colors.dart';

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
          trailing: widget.language == "default"
              ? const Icon(Icons.check_circle,
                  size: 30, color: MoodleColors.blue)
              : const Icon(Icons.circle, size: 30, color: MoodleColors.blue),
        ),
        ListTile(
          title: Text("English"),
          onTap: () {
            setState(() {
              widget.language = "en";
            });
          },
          // ignore: unnecessary_new
          trailing: widget.language == "en"
              ? const Icon(Icons.check_circle,
                  size: 30, color: MoodleColors.blue)
              : const Icon(Icons.circle, size: 30, color: MoodleColors.blue),
        ),
        ListTile(
          title: Text("Việt Nam"),
          onTap: () {
            setState(() {
              widget.language = "vi";
            });
          },
          trailing: widget.language == "vi"
              ? const Icon(Icons.check_circle,
                  size: 30, color: MoodleColors.blue)
              : const Icon(Icons.circle, size: 30, color: MoodleColors.blue),
        ),
      ],
    );
  }
}
