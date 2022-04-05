import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/models/course_category/course_category.dart';
import 'package:moodle_mobile/view/course_category/category_folder_detail.dart';

class CourseCategoryListTile extends StatefulWidget {
  const CourseCategoryListTile({Key? key, required this.data, this.margin})
      : super(key: key);
  final CourseCategory data;
  final EdgeInsetsGeometry? margin;
  @override
  _CourseCategoryListTileState createState() => _CourseCategoryListTileState();

  toList() {}
}

class _CourseCategoryListTileState extends State<CourseCategoryListTile> {
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
            setState(() {
              showChild = !showChild;
              if (showChild) {
                if (widget.data.coursecount > 0) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          CourseCategoryFolderScreen(data: widget.data),
                    ),
                  );
                  showChild = !showChild;
                } else
                  listChild.addAll(widget.data.child);
              } else
                listChild.clear();
            });
          },
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(width: 8),
                  Icon(Icons.folder_open_outlined, color: Colors.black),
                  SizedBox(width: 8),
                  Text(widget.data.name,
                      style: TextStyle(
                          fontWeight: (widget.data.parent == 0)
                              ? FontWeight.w900
                              : FontWeight.normal)),
                  Expanded(
                    child: Row(
                      children: [
                        Text(widget.data.coursecount.toString()),
                        Icon(
                          showChild ? Icons.arrow_drop_down : Icons.arrow_right,
                          color: Colors.black,
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.end,
                    ),
                  ),
                ],
              ),
              showChild ? Divider() : Container(),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: listChild
                    .map((e) => CourseCategoryListTile(data: e, margin: null))
                    .toList(),
              ),
            ],
          ),
        ));
  }
}
