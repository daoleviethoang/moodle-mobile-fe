import 'package:flutter/material.dart';
import 'package:moodle_mobile/models/course_category/course_category.dart';
import 'package:moodle_mobile/screens/course_category/category_folder_detail.dart';

class CourseCategoryListTitle extends StatefulWidget {
  const CourseCategoryListTitle({Key? key, required this.data, this.margin})
      : super(key: key);
  final CourseCategory data;
  final EdgeInsetsGeometry? margin;
  @override
  _CourseCategoryListTitleState createState() =>
      _CourseCategoryListTitleState();

  toList() {}
}

class _CourseCategoryListTitleState extends State<CourseCategoryListTitle> {
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
                          Icons.arrow_right,
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
                    .map((e) => CourseCategoryListTitle(data: e, margin: null))
                    .toList(),
              ),
            ],
          ),
        ));
  }
}
