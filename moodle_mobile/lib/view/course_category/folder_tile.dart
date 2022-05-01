import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/models/course_category/course_category.dart';
import 'package:moodle_mobile/view/course_category/category_folder_detail.dart';

class FolderTile extends StatefulWidget {
  const FolderTile({Key? key, required this.data, this.margin})
      : super(key: key);
  final CourseCategory data;
  final EdgeInsetsGeometry? margin;
  @override
  _FolderTileState createState() => _FolderTileState();

  toList() {}
}

class _FolderTileState extends State<FolderTile> {
  bool showChild = false;
  List<CourseCategory> listChild = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: widget.margin,
        decoration: BoxDecoration(
          color: MoodleColors.grey_soft,
          border: Border.all(
            width: 5,
            color: Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    CourseCategoryFolderScreen(data: widget.data),
              ),
            );
          },
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(width: 8),
                  Icon(Icons.folder_open_outlined, color: Colors.black),
                  SizedBox(width: 8),
                  Text(widget.data.name,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      )),
                  Expanded(
                    child: Row(
                      children: [
                        Text((widget.data.sumCoursecount +
                                widget.data.coursecount)
                            .toString()),
                        Icon(
                          Icons.arrow_right,
                          color: Colors.black,
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.end,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
