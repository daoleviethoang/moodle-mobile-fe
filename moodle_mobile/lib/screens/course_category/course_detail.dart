import 'package:flutter/material.dart';
import 'package:moodle_mobile/models/course_category/course_category_course.dart';
import 'package:moodle_mobile/screens/course_category/category_folder_detail.dart';

class CourseTile extends StatefulWidget {
  const CourseTile({Key? key, required this.data, this.margin})
      : super(key: key);
  final CourseCategoryCourse data;
  final EdgeInsetsGeometry? margin;
  @override
  _CourseTileState createState() => _CourseTileState();

  toList() {}
}

class _CourseTileState extends State<CourseTile> {
  bool showChild = false;
  List<CourseCategoryCourse> listChild = [];

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
          onTap: () {},
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(width: 8),
                  Icon(Icons.class_, color: Colors.black),
                  Text(widget.data.displayname),
                  Expanded(
                    child: Row(
                      children: [
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
