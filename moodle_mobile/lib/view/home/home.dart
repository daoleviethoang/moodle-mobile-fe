import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/models/contant/contant_model.dart';
import 'package:moodle_mobile/view/common/select_course_filter.dart';
import 'package:moodle_mobile/view/home/courses_view.dart';
import 'package:moodle_mobile/view/course_category/index.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ContantModel arrangeTypeSelected = ContantExtension.courseArrangeSelected;
  ContantModel statusTypeSelected = ContantExtension.courseStatusSelected;
  bool showOnlyStarSelected = false;
  bool isFilter = false;

  CategoryType categoryType = CategoryType.my;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          const EdgeInsets.only(left: 6.0, right: 6.0, top: 10.0, bottom: 15),
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
    return PopularCourseListView(
        arrangeTypeSelected: arrangeTypeSelected,
        statusTypeSelected: statusTypeSelected,
        showOnlyStarSelected: showOnlyStarSelected,
        isFilter: isFilter);
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
      child: Stack(
        children: <Widget>[
          getListCoursesUI(),
          getDropdownStatus(),
        ],
      ),
    );
  }

  Widget getAllCoursesUI() {
    return Expanded(
      child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: const Padding(
            padding: EdgeInsets.only(top: 0, left: 5, right: 5),
            child: CourseCategoryScreen(),
          ),
        ),
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
    return SelectCourseFilter(
      arrangeTypeSelected,
      statusTypeSelected,
      showOnlyStarSelected,
      isFilter,
      (arrangeTypeSelected, statusTypeSelected, showOnlyStarSelected,
          isFilter) {
        setState(() {
          this.arrangeTypeSelected = arrangeTypeSelected;
          this.statusTypeSelected = statusTypeSelected;
          this.showOnlyStarSelected = showOnlyStarSelected;
          this.isFilter = isFilter;
        });
      },
    );
  }
}

enum CategoryType { my, all }
