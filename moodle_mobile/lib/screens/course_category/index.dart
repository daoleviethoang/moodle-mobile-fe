import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:moodle_mobile/models/course_category/course_category.dart';
import 'package:moodle_mobile/screens/course_category/category_course_list_tile.dart';

class CourseCategoryScreen extends StatefulWidget {
  const CourseCategoryScreen({Key? key}) : super(key: key);

  @override
  _CourseCategoryScreenState createState() => _CourseCategoryScreenState();
}

class _CourseCategoryScreenState extends State<CourseCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: ReadJsonData(),
          builder: (context, data) {
            if (data.hasError) {
              return const Center(child: Text("Error"));
            }
            List<CourseCategory> categorys = [];
            if (data.hasData) {
              categorys = data.data as List<CourseCategory>;
            }

            return SingleChildScrollView(
                child: Container(
                    child: ListView(
              primary: false,
              shrinkWrap: true,
              children: categorys
                  .map((e) => CourseCategoryListTile(
                        data: e,
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.02,
                            left: MediaQuery.of(context).size.width * 0.05,
                            right: MediaQuery.of(context).size.width * 0.05),
                      ))
                  .toList(),
            )));
          }),
    );
  }
}

Future<List<CourseCategory>> ReadJsonData() async {
  // read json file
  final jsonData = await rootBundle.rootBundle
      .loadString('assets/dummy/course_category.json');
  final list = json.decode(jsonData) as List<dynamic>;

  List<CourseCategory> categories =
      list.map((e) => CourseCategory.fromJson(e)).toList();

  // group by parent id
  final Map<int, CourseCategory> categoryMap = HashMap();

  // get max depth
  int maxDepth = 0;
  categories.forEach((element) {
    if (element.depth > maxDepth) {
      maxDepth = element.depth;
    }
  });

  // group folder
  for (var i = maxDepth - 1; i >= 0; i--) {
    categories.forEach((element) {
      if (element.depth >= i && element.depth <= i + 1) {
        if (categoryMap.containsKey(element.parent)) {
          categoryMap[element.parent]!.addChild(element);
          categoryMap.removeWhere((key, value) => key == element.id);
        } else {
          final iter = <int, CourseCategory>{element.id: element};
          categoryMap.addEntries(iter.entries);
        }
      }
    });
  }

  return categoryMap.values.toList();
}
