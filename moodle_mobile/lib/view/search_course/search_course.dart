import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/data/network/apis/search/search_api.dart';
import 'package:moodle_mobile/models/course/courses.dart';
import 'package:moodle_mobile/view/course_category/courses_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CoursesSearch extends SearchDelegate<CourseOverview?> {
  final String token;
  CoursesSearch({required this.token});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(
          Icons.clear,
          color: MoodleColors.blue,
        ),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back,
        color: MoodleColors.blue,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  Future<List<CourseOverview>> searchCourse() async {
    List<CourseOverview> temp = [];
    temp = await SearchApi().searchCourse(token, query);

    return temp;
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: searchCourse(),
      builder: (context, snapshot) {
        if (query == '') {
          return Container(
            color: Colors.white,
            child: Center(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  width: 50,
                  height: 50,
                  child: Icon(
                    Icons.search,
                    size: 50,
                    color: Colors.black,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.search_course,
                  style: const TextStyle(color: Colors.black),
                )
              ],
            )),
          );
        }
        if (snapshot.error != null) {
          return Center(
            child: Text(AppLocalizations.of(context)!.error_connect),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          List<CourseOverview> courses = snapshot.data as List<CourseOverview>;
          if (courses.isEmpty) {
            return Container(
              color: Colors.white,
              child: Center(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context)!.empty_data,
                    style: const TextStyle(color: Colors.black),
                  )
                ],
              )),
            );
          } else {
            return CategoryCourseListView(
              courses: courses,
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      color: Colors.white,
    );
  }
}