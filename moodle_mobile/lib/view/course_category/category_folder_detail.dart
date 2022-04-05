import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:moodle_mobile/models/course_category/course_category.dart';
import 'package:moodle_mobile/models/course_category/course_category_course.dart';
import 'package:moodle_mobile/models/courses.dart';
import 'package:moodle_mobile/view/course_category/courses_view.dart';
import 'package:moodle_mobile/view/course_category/folder_tile.dart';

class CourseCategoryFolderScreen extends StatefulWidget {
  final CourseCategory data;
  const CourseCategoryFolderScreen({Key? key, required this.data})
      : super(key: key);

  @override
  _CourseCategoryFolderScreenState createState() =>
      _CourseCategoryFolderScreenState();
}

class _CourseCategoryFolderScreenState
    extends State<CourseCategoryFolderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverAppBar(
          title: Text(
            widget.data.name,
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.black,
          ),
        ),
      ],
      body: FutureBuilder(
          future: ReadJsonData(),
          builder: (context, data) {
            if (data.hasError) {
              return const Center(child: Text("Error"));
            }
            List<Course> courses = [];
            if (data.hasData) {
              List<CourseCategoryCourse> _courses =
                  data.data as List<CourseCategoryCourse>;
              courses = _courses
                  .map((e) => Course(
                      id: e.id,
                      title: e.displayname,
                      tag: "18HTTT",
                      teacher: e.contacts!.map((f) => f.fullname).toList()))
                  .toList();
            } else {
              return Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  widget.data.child.isNotEmpty
                      ? Container(
                          child: Text("Danh mục khóa học"),
                          margin: const EdgeInsets.only(
                              top: 5.0, left: 15.0, bottom: 5),
                        )
                      : Container(),
                  Container(
                      child: ListView(
                    primary: false,
                    shrinkWrap: true,
                    children: widget.data.child
                        .map((e) => FolderTile(
                            data: e,
                            margin: EdgeInsets.only(
                              top: 5,
                              left: 10,
                              right: 10,
                            )))
                        .toList(),
                  )),
                  courses.isNotEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text("Khóa học"),
                              margin: const EdgeInsets.only(
                                  top: 10.0, left: 15.0, bottom: 5),
                            ),
                            CategoryCourseListView(courses: courses)
                          ],
                        )
                      : Container(),
                ]));
          }),
    ));
  }
}

Future<List<CourseCategoryCourse>> ReadJsonData() async {
  // read json file
  final jsonData = await rootBundle.rootBundle
      .loadString('assets/dummy/course_category_in_folder.json');
  final list = json.decode(jsonData) as List<dynamic>;

  List<CourseCategoryCourse> course =
      list.map((e) => CourseCategoryCourse.fromJson(e)).toList();

  return course;
}
