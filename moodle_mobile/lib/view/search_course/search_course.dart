import 'package:flutter/material.dart';
import 'package:moodle_mobile/data/network/apis/search/search_api.dart';
import 'package:moodle_mobile/models/course/courses.dart';
import 'package:moodle_mobile/view/course_category/courses_view.dart';

class CoursesSearch extends SearchDelegate<CourseOverview?> {
  final String token;
  CoursesSearch({required this.token});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.clear,
          color: Colors.blue,
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
      icon: Icon(
        Icons.arrow_back,
        color: Colors.blue,
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
                SizedBox(
                  width: 50,
                  height: 50,
                  child: Icon(
                    Icons.search,
                    size: 50,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Enter to search.',
                  style: TextStyle(color: Colors.black),
                )
              ],
            )),
          );
        }
        if (snapshot.error != null) {
          return Center(
            child: Text("Error loading"),
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
                    'No results found',
                    style: TextStyle(color: Colors.black),
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
