import 'package:flutter/material.dart';
import 'package:moodle_mobile/view/activity/album_screen.dart';

class AlbumTile extends StatefulWidget {
  const AlbumTile({Key? key}) : super(key: key);

  @override
  State<AlbumTile> createState() => _AlbumTileState();
}

class _AlbumTileState extends State<AlbumTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text("Name"),
            TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                    return const AlbumScreen();
                  }));
                },
                child: Text("Xem tất cả")),
          ],
        ),
      ],
    );
  }
}
