import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/data/network/apis/course_category/course_category_api.dart';
import 'package:moodle_mobile/models/course_category/course_category.dart';
import 'package:moodle_mobile/view/course_category/category_course_list_tile.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CourseCategoryScreen extends StatefulWidget {
  const CourseCategoryScreen({Key? key}) : super(key: key);

  @override
  _CourseCategoryScreenState createState() => _CourseCategoryScreenState();
}

class _CourseCategoryScreenState extends State<CourseCategoryScreen> {
  late UserStore _userStore;

  Future<List<CourseCategory>> readData() async {
    // read json file
    List<CourseCategory> categories = [];
    try {
      categories =
          await CourseCategoryApi().getCourseCategory(_userStore.user.token);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.load_category_fail)));
    }

    if (categories.isNotEmpty) {
      // group by parent id
      final Map<int, CourseCategory> categoryMap = HashMap();

      // get max depth
      int maxDepth = 0;
      for (CourseCategory element in categories) {
        if (element.depth! > maxDepth) {
          maxDepth = element.depth ?? 0;
        }
      }

      // group folder
      for (var i = maxDepth - 1; i >= 0; i--) {
        categories.forEach((element) {
          if (element.depth! >= i && element.depth! <= i + 1) {
            if (categoryMap.containsKey(element.parent)) {
              categoryMap[element.parent]!.addChild(element);
              categoryMap[element.parent]!.sumCoursecount +=
                  element.coursecount!;
              categoryMap[element.parent]!.sumCoursecount +=
                  element.sumCoursecount;
              categoryMap.removeWhere((key, value) => key == element.id);
            } else {
              final iter = <int, CourseCategory>{element.id!: element};
              categoryMap.addEntries(iter.entries);
            }
          }
        });
      }

      return categoryMap.values.toList();
    }
    return categories;
  }

  @override
  void initState() {
    _userStore = GetIt.instance<UserStore>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: readData(),
          builder: (context, data) {
            if (data.hasError) {
              return const Center(child: Text("Error"));
            }
            List<CourseCategory> categories = [];
            if (data.hasData) {
              categories = data.data as List<CourseCategory>;
            } else {
              return const Center(child: CircularProgressIndicator());
            }

            final tilePadVert = MediaQuery.of(context).size.height * 0.01;
            final tilePadHoz = MediaQuery.of(context).size.height * 0.02;
            return RefreshIndicator(
              onRefresh: () async => readData(),
              child: ListView(
                primary: false,
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  Container(height: 2),
                  ...categories.map(
                    (e) => CourseCategoryListTile(
                        data: e,
                        margin: EdgeInsets.symmetric(
                          vertical: tilePadVert,
                          horizontal: tilePadHoz,
                        )),
                  ).toList(),
                  Container(height: 2),
                ],
              ),
            );
          }),
    );
  }
}