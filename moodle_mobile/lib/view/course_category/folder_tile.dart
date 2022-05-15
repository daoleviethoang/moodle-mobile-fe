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
          color: MoodleColors.blue_soft,
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
              Container(height: 8),
              Row(
                children: [
                  SizedBox(width: 8),
                  Icon(Icons.folder_open_outlined, color: MoodleColors.blueDark),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(widget.data.name ?? "",
                        softWrap: true,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: (widget.data.parent == 0)
                                ? FontWeight.w900
                                : FontWeight.normal,
                            color: MoodleColors.blueDark)),
                  ),
                  Row(
                    children: [
                      Text((widget.data.sumCoursecount +
                          (widget.data.coursecount ?? 0))
                          .toString(),
                        style: const TextStyle(color: MoodleColors.blueDark),),
                      Icon(
                        showChild ? Icons.arrow_drop_down : Icons.arrow_right,
                        color: MoodleColors.blueDark,
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.end,
                  ),
                ],
              ),
              Container(height: 8),
            ],
          ),
        ));
  }
}