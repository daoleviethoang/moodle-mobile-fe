import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/view/activity/album_screen.dart';
import 'package:moodle_mobile/view/activity/image_tile.dart';

class AlbumTile extends StatelessWidget {
  final List<String> images;
  const AlbumTile({Key? key, required this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "4/4/2022",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: MoodleColors.black80,
              ),
              textScaleFactor: 1.3,
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                    return AlbumScreen(
                      images: images,
                      title: "4/4/2022",
                    );
                  }));
                },
                child: Text("Xem tất cả",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ))),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child:
              Row(children: images.map((e) => ImageAlbumTile(src: e)).toList()),
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
