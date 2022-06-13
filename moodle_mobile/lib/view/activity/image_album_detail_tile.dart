import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/colors.dart';

class ImageAlbumDetailTile extends StatelessWidget {
  final String src;
  final bool isChoose;
  final Function(bool) setLongPress;
  const ImageAlbumDetailTile(
      {Key? key,
      required this.src,
      required this.isChoose,
      required this.setLongPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: isChoose
          ? () {
              setLongPress(false);
            }
          : () {
              setLongPress(true);
            },
      onTap: isChoose
          ? () {
              setLongPress(false);
            }
          : () {},
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
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
          isChoose
              ? Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    // onPressed: () {},
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
