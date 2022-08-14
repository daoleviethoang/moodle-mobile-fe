import 'package:flutter/material.dart';
import 'dart:io';

import 'package:moodle_mobile/view/viewer/image_viewer.dart';

class ImageAlbumDetailTile extends StatelessWidget {
  final String src;
  final String name;
  final bool isChoose;
  final bool isChooseInAlbum;
  final Function(bool) setLongPress;
  final String? filePath;
  const ImageAlbumDetailTile(
      {Key? key,
      required this.src,
      required this.isChoose,
      required this.isChooseInAlbum,
      required this.setLongPress,
      required this.name,
      required this.filePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return filePath == ""
        ? const Center(child: CircularProgressIndicator())
        : GestureDetector(
            onLongPress: isChoose
                ? () {
                    setLongPress(false);
                  }
                : () {
                    setLongPress(true);
                  },
            onTap: isChooseInAlbum
                ? (isChoose
                    ? () {
                        setLongPress(false);
                      }
                    : () {
                        setLongPress(true);
                      })
                : () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                      return ImageViewer(
                        title: name,
                        url: src,
                      );
                    }));
                  },
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: filePath == null
                            ? Image.network(
                                src,
                                width:
                                    (MediaQuery.of(context).size.width - 3) / 2,
                                fit: BoxFit.fitWidth,
                              )
                            : Image.file(
                                File(filePath ?? ""),
                                width:
                                    (MediaQuery.of(context).size.width - 3) / 2,
                                fit: BoxFit.fitWidth,
                                errorBuilder: (context, exception, stackTrace) {
                                  return Text(filePath!);
                                },
                              )),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                          )),
                    ),
                  ],
                ),
                if (isChoose)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      // onPressed: () {},
                      decoration: const BoxDecoration(
                        color: Colors.blueAccent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          );
  }
}