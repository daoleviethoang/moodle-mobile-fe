import 'package:flutter/material.dart';

class ImageAlbumTile extends StatelessWidget {
  final String src;
  const ImageAlbumTile({Key? key, required this.src}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(width: 0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Image.network(
              src,
              height: 100,
              fit: BoxFit.fitHeight,
            ),
          ),
          SizedBox(height: 5),
          Container(
            padding: EdgeInsets.only(left: 5),
            child: Text("Ảnh",
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                )),
          ),
        ],
      ),
    );
  }
}
