import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/screens/common/dropdown.dart';
import 'package:moodle_mobile/screens/course_details.dart';
import 'package:moodle_mobile/screens/home/courses_view.dart';
import 'package:moodle_mobile/screens/course_category/index.dart';

import '../../models/status.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CategoryType categoryType = CategoryType.my;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MoodleColors.white,
      body: Column(
        children: <Widget>[
          getCategoryUI(),
          getScreenTabUI(categoryType),
        ],
      ),
    );
  }

  Widget getCategoryUI() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 6.0, right: 6.0, top: 10.0, bottom: 15.0),
      child: Center(
        child: Row(
          children: <Widget>[
            getButtonUI(CategoryType.my, categoryType == CategoryType.my),
            getButtonUI(CategoryType.all, categoryType == CategoryType.all)
          ],
        ),
      ),
    );
  }

  Widget getListCoursesUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          getDropdownStatus(),
          Flexible(
            child: PopularCourseListView(
              callBack: () => moveToCourseDetail(),
            ),
          )
        ],
      ),
    );
  }

  Widget getScreenTabUI(CategoryType categoryTypeData) {
    if (CategoryType.my == categoryTypeData) {
      return getMyCoursesUI();
    } else if (CategoryType.all == categoryTypeData) {
      return getAllCoursesUI();
    }
    return getMyCoursesUI();
  }

  Widget getMyCoursesUI() {
    return Expanded(
      child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.only(top: 0, left: 5, right: 5),
            child: Column(
              children: <Widget>[
                Flexible(
                  child: getListCoursesUI(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getAllCoursesUI() {
    return Expanded(
      child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.only(top: 0, left: 5, right: 5),
            child: Column(
              children: <Widget>[
                Flexible(
                  child: CourseCategoryScreen(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void moveToCourseDetail() {
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) =>
            const CourseDetailsScreen(courseId: 'course-id'),
      ),
    );
  }

  Widget getButtonUI(CategoryType categoryTypeData, bool isSelected) {
    String txt = '';
    if (CategoryType.my == categoryTypeData) {
      txt = 'My Courses';
    } else if (CategoryType.all == categoryTypeData) {
      txt = 'All Courses';
    }
    return Expanded(
      child: Container(
        height: 48,
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isSelected ? MoodleColors.blueButton : MoodleColors.white,
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          boxShadow: [
            BoxShadow(
              color: MoodleColors.black.withOpacity(0.25),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.white24,
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            onTap: () {
              setState(() {
                categoryType = categoryTypeData;
              });
            },
            child: Center(
              child: Text(
                txt,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  letterSpacing: 0.27,
                  color: isSelected ? MoodleColors.blue : MoodleColors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getDropdownStatus() {
    return SelectDropList(
      OptionItem.optionItemSelected,
      DropListModel.dropListModel,
      (optionItem) {
        optionItem;
        setState(() {});
      },
    );
  }
}

enum CategoryType { my, all }
