import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/data/network/apis/contact/contact_service.dart';
import 'package:moodle_mobile/data/network/apis/course/course_service.dart';
import 'package:moodle_mobile/models/contact/contact.dart';
import 'package:moodle_mobile/models/contant/contant_model.dart';
import 'package:moodle_mobile/models/contant/course_arrange.dart';
import 'package:moodle_mobile/models/contant/course_status.dart';
import 'package:moodle_mobile/models/course/course.dart';
import 'package:moodle_mobile/models/course/courses.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moodle_mobile/view/common/course_view.dart';

import '../../constants/colors.dart';

class PopularCourseListView extends StatefulWidget {
  final ContantModel arrangeTypeSelected;
  final ContantModel statusTypeSelected;
  final bool showOnlyStarSelected;
  final bool isFilter;
  final bool isSelectOption;
  final Function(CourseOverview courseSelected) onCourseMoreSelected;

  PopularCourseListView(
      {Key? key,
      required this.arrangeTypeSelected,
      required this.statusTypeSelected,
      required this.showOnlyStarSelected,
      required this.isFilter,
      required this.onCourseMoreSelected,
      required this.isSelectOption})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _PopularCourseListViewState();
}

class _PopularCourseListViewState extends State<PopularCourseListView>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<CourseOverview> coursesOverview = [];
  List<CourseOverview> coursesOverviewOld = [];

  bool isLoad = false;
  late UserStore _userStore;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    _userStore = GetIt.instance<UserStore>();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoad) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (widget.isSelectOption) {
      print("vao");
      //getData();
    }
    if (widget.isFilter) {
      print("filter");
      List<CourseOverview> newCourseOverview = filterCourseHomePage();
      if (newCourseOverview.isEmpty) {
        return Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const <Widget>[
            Icon(Icons.notifications_none, size: 50),
            Padding(padding: EdgeInsets.all(20)),
            Text(
              "Your search didn't match any courses.",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 0.27,
                  color: MoodleColors.black),
            ),
          ],
        ));
      } else {
        setState(() {
          coursesOverview = newCourseOverview;
        });
      }
    }

    return Padding(
      padding: const EdgeInsets.only(left: 0, top: 50),
      child: ListView(
        padding: const EdgeInsets.all(8),
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        children: List<Widget>.generate(
          coursesOverview.length,
          (int index) {
            final int count = coursesOverview.length;
            final Animation<double> animation =
                Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: animationController!,
                curve: Interval((1 / count) * index, 1.0,
                    curve: Curves.fastOutSlowIn),
              ),
            );
            animationController?.forward();
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: CourseView(
                  coursesOverview[index], animationController, animation,
                  ((selectedCourseMoreId) {
                widget.onCourseMoreSelected(selectedCourseMoreId);
              })),
            );
          },
        ),
      ),
    );
  }

  getData() async {
    setState(() {
      isLoad = true;
    });

    await Future<dynamic>.delayed(const Duration(milliseconds: 2));
    try {
      List<Course> courses = await CourseService()
          .getCourses(_userStore.user.token, _userStore.user.id);

      setState(() {
        coursesOverview = courses
            .map((element) => CourseOverview(
                id: element.id,
                title: element.displayname,
                isfavourite: element.isfavourite,
                hidden: element.hidden,
                startdate: element.startdate,
                enddate: element.enddate,
                lastaccess: element.lastaccess,
                teacher: []))
            .toList();
      });
      setState(() {
        isLoad = false;
      });
      for (var element in courses) {
        List<Contact> contacts = await ContactService()
            .getContacts(_userStore.user.token, element.id);
        setState(() {
          coursesOverview.where((e) => element.id == e.id).first.teacher =
              contacts;
        });
      }
      coursesOverviewOld.addAll(coursesOverview);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
    }
    setState(() {
      isLoad = false;
    });
  }

  List<CourseOverview> filterCourseHomePage() {
    List<CourseOverview> coursesOverviewFilter = [];
    coursesOverviewFilter.addAll(coursesOverviewOld);
    DateTime currentPhoneDate = DateTime.now(); //DateTime
    int currentTimeStamp =
        Timestamp.fromDate(currentPhoneDate).seconds; //To TimeStamp

    if (widget.showOnlyStarSelected) {
      coursesOverviewFilter = coursesOverviewFilter
          .where((element) => element.isfavourite)
          .toList();
    }
    switch (widget.statusTypeSelected.key) {
      case CourseStatus.past:
        {
          coursesOverviewFilter = coursesOverviewFilter
              .where((element) =>
                  (element.enddate < currentTimeStamp && element.enddate != 0))
              .toList();
          break;
        }
      case CourseStatus.in_progress:
        {
          coursesOverviewFilter = coursesOverviewFilter
              .where((element) =>
                  (element.enddate >= currentTimeStamp ||
                      element.enddate == 0) &&
                  element.startdate <= currentTimeStamp)
              .toList();
          break;
        }
      case CourseStatus.future:
        {
          coursesOverviewFilter = coursesOverviewFilter
              .where((element) => (element.startdate > currentTimeStamp))
              .toList();
          break;
        }
      case CourseStatus.removed_from_view:
        {
          coursesOverviewFilter =
              coursesOverviewFilter.where((element) => element.hidden).toList();
          break;
        }
      case CourseStatus.all_expand:
        {
          coursesOverviewFilter = coursesOverviewFilter
              .where((element) => element.hidden == false)
              .toList();
          break;
        }
      default:
        {
          break;
        }
    }
    if (widget.arrangeTypeSelected.key == CourseArrange.name) {
      coursesOverviewFilter.sort((a, b) => a.title.compareTo(b.title));
    } else if (widget.arrangeTypeSelected.key == CourseArrange.last_accessed) {
      coursesOverviewFilter.sort((a, b) {
        if (a.lastaccess > b.lastaccess)
          return 1;
        else
          return 0;
      });
    }
    return coursesOverviewFilter;
  }
}
