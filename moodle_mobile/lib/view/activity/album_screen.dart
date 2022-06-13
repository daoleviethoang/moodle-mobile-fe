import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/constants/dimens.dart';
import 'package:moodle_mobile/view/activity/image_album_detail_tile.dart';
import 'package:moodle_mobile/view/common/custom_text_field.dart';

class AlbumScreen extends StatefulWidget {
  final List<String> images;
  final String title;
  const AlbumScreen({Key? key, required this.images, required this.title})
      : super(key: key);

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  List<bool> chooseImages = [];
  bool canSave = false;
  bool isRemove = false;
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    while (chooseImages.length < widget.images.length) {
      chooseImages.add(false);
    }
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            snap: true,
            actions: <Widget>[
              SizedBox(
                width: 60,
                height: 60,
                child: IconButton(
                  iconSize: 28,
                  icon: const Icon(Icons.delete),
                  color: MoodleColors.white,
                  onPressed: () async {},
                ),
              ),
              canSave
                  ? SizedBox(
                      width: 60,
                      height: 60,
                      child: IconButton(
                        iconSize: 28,
                        icon: const Icon(Icons.save),
                        color: MoodleColors.white,
                        onPressed: () async {},
                      ),
                    )
                  : Container(),
            ],
            title: TextButton(
              onPressed: () {
                showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      titlePadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Album mới',
                            textScaleFactor: 0.8,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Nhập tên cho album này',
                            textScaleFactor: 0.8,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          CustomTextFieldWidget(
                            controller: nameController,
                            hintText: "Nhập tiêu đề",
                            haveLabel: false,
                            borderRadius: Dimens.default_border_radius,
                          )
                        ],
                      ),
                      actions: [
                        Row(children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Cancel",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  )),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      MoodleColors.grey),
                                  shape: MaterialStateProperty.all(
                                      const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0))))),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Save",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  )),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      MoodleColors.blue),
                                  shape: MaterialStateProperty.all(
                                      const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0))))),
                            ),
                          ),
                        ]),
                      ],
                    );
                  },
                );
              },
              child: Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
                overflow: TextOverflow.clip,
              ),
            ),
            leading: TextButton(
              style: TextButton.styleFrom(
                primary: Colors.white,
              ),
              child: const Icon(CupertinoIcons.back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
        body: GridView(
          padding: EdgeInsets.only(left: 5, right: 5),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
          ),
          children: widget.images
              .map((e) => ImageAlbumDetailTile(
                    src: e,
                    isChoose: chooseImages[widget.images.indexOf(e)],
                    setLongPress: (bool value) {
                      setState(() {
                        chooseImages[widget.images.indexOf(e)] = value;
                      });
                    },
                  ))
              .toList(),
        ),
      ),
      floatingActionButton: chooseImages.any((element) => element == true)
          ? FloatingActionButton(
              child: const Icon(
                Icons.delete,
                color: MoodleColors.black80,
              ),
              foregroundColor: MoodleColors.white,
              backgroundColor: MoodleColors.white,
              onPressed: () {},
            )
          : FloatingActionButton(
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              foregroundColor: MoodleColors.blue,
              backgroundColor: MoodleColors.blue,
              onPressed: () {},
            ),
    );
  }
}
