import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:moodle_mobile/models/course_category/course_category.dart';
import 'package:moodle_mobile/models/course_category/course_category_course.dart';
import 'package:moodle_mobile/screens/course_category/category_course_list_tile.dart';
import 'package:moodle_mobile/screens/course_category/course_tile.dart';
import 'package:moodle_mobile/screens/course_category/folder_tile.dart';

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
            List<CourseCategoryCourse> courses = [];
            if (data.hasData) {
              courses = data.data as List<CourseCategoryCourse>;
            }

            return SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  widget.data.child.isNotEmpty
                      ? Container(
                          child: Text("Danh muc khoa hoc"),
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
                      ? Container(
                          child: Text("Khoa hoc"),
                          margin: const EdgeInsets.only(
                              top: 10.0, left: 15.0, bottom: 5),
                        )
                      : Container(),
                  Container(
                      child: ListView(
                    primary: false,
                    shrinkWrap: true,
                    children: courses
                        .map((e) => CourseTile(
                            data: e,
                            margin: EdgeInsets.only(
                              top: 5,
                              left: 10,
                              right: 10,
                            )))
                        .toList(),
                  ))
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
