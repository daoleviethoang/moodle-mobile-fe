import 'package:flutter/material.dart';
import 'package:moodle_mobile/models/course_category/course_category.dart';
import 'package:moodle_mobile/screens/course_category/category_folder_detail.dart';

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
          color: Color.fromARGB(255, 199, 195, 195),
          border: Border.all(
            width: 5,
            color: Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: InkWell(
          onTap: () {
            if (widget.data.child.isNotEmpty) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      CourseCategoryFolderScreen(data: widget.data),
                ),
              );
            }
          },
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(width: 8),
                  Icon(Icons.folder, color: Colors.black),
                  Text(widget.data.name),
                  Expanded(
                    child: Row(
                      children: [
                        Text(widget.data.coursecount.toString()),
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
