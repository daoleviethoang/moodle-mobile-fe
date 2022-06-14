import 'package:flutter/material.dart';

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
    return Container(
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
              width: 120,
              fit: BoxFit.fitWidth,
            ),
          ),
          SizedBox(height: 5),
          Container(
            padding: EdgeInsets.only(left: 5),
            child: Text(name,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                )),
          ),
        ],
      ),
    );
  }
}
