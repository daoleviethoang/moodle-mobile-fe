import 'package:flutter/material.dart';

class RenameFileTiles extends StatefulWidget {
  String filename = "";
  RenameFileTiles({Key? key, required this.filename}) : super(key: key);

  @override
  _RenameFileTilesState createState() => _RenameFileTilesState();
}

class _RenameFileTilesState extends State<RenameFileTiles> {
  TextEditingController c = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      c = TextEditingController(text: widget.filename);
    });
  }

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: c,
          onChanged: (String newName) {
            setState(() {
              widget.filename = newName;
            });
          },
        )
      ],
    );
  }
}
