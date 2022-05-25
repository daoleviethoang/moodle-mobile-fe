import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/data/network/apis/course_category/course_category_api.dart';
import 'package:moodle_mobile/models/course_category/course_category.dart';
import 'package:moodle_mobile/models/course_category/course_category_course.dart';
import 'package:moodle_mobile/models/course/courses.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/course_category/courses_view.dart';
import 'package:moodle_mobile/view/course_category/folder_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.load_category_fail)));
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
          floating: true,
          snap: true,
          title: Text(
            widget.data.name ?? "",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
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
                          child: Text(
                              AppLocalizations.of(context)!.course_category),
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
                              child: Text(AppLocalizations.of(context)!.course),
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
