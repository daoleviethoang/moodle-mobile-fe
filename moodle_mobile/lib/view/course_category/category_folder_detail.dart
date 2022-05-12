import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/data/network/apis/course_category/course_category_api.dart';
import 'package:moodle_mobile/models/course_category/course_category.dart';
import 'package:moodle_mobile/models/course_category/course_category_course.dart';
import 'package:moodle_mobile/models/course/courses.dart';
import 'package:moodle_mobile/models/user/user_overview.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
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
  late UserStore _userStore;

  Future<List<CourseCategoryCourse>> readData() async {
    List<CourseCategoryCourse> course = [];
    try {
      course = await CourseCategoryApi()
          .getCourseInFolder(_userStore.user.token, widget.data.id ?? 0);
    } catch (e) {
      const snackBar = SnackBar(
          content:
              Text("Loading course category fail, please try again later"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    return course;
  }

  @override
  void initState() {
    _userStore = GetIt.instance<UserStore>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverAppBar(
          title: Text(
            widget.data.name ?? "",
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
          future: readData(),
          builder: (context, data) {
            List<CourseOverview> courses = [];
            if (data.hasData) {
              List<CourseCategoryCourse> _courses =
                  data.data as List<CourseCategoryCourse>;
              courses = _courses
                  .map((e) => CourseOverview(
                      id: e.id, title: e.displayname, teacher: e.contacts!))
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
                    padding: EdgeInsets.only(top: 0),
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