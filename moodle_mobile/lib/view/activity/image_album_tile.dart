import 'package:flutter/material.dart';
import 'package:moodle_mobile/view/viewer/image_viewer.dart';

class ImageAlbumTile extends StatelessWidget {
  final String src;
  final String name;
  const ImageAlbumTile({
    Key? key,
    required this.src,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return ImageViewer(
            title: name,
            url: src,
          );
        }));
      },
      child: Container(
        margin: const EdgeInsets.only(left: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Image.network(
                src,
                width: 100,
                height: 100,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(height: 5),
            Container(
              width: 110,
              padding: EdgeInsets.only(left: 5),
              child: Text(name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
