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
import 'package:moodle_mobile/view/course_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constants/colors.dart';

class PopularCourseListView extends StatefulWidget {
  final ContantModel arrangeTypeSelected;
  final ContantModel statusTypeSelected;
  final bool showOnlyStarSelected;
  final bool isFilter;

  PopularCourseListView(
      {Key? key,
      required this.arrangeTypeSelected,
      required this.statusTypeSelected,
      required this.showOnlyStarSelected,
      required this.isFilter})
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
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    _userStore = GetIt.instance<UserStore>();
    super.initState();
    getData();
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
        List<CourseOverview> coursesOverviewList = courses
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
        coursesOverviewList.sort((a, b) => a.title.compareTo(b.title));
        coursesOverview = coursesOverviewList;
        coursesOverviewOld = coursesOverview;
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
    }
    setState(() {
      isLoad = false;
    });
  }

  List<CourseOverview> filterCourseHomePage() {
    List<CourseOverview> coursesOverviewFilter = coursesOverview;
    DateTime currentPhoneDate = DateTime.now(); //DateTime
    int currentTimeStamp =
        Timestamp.fromDate(currentPhoneDate).seconds; //To TimeStamp

    setState(() {
      isLoad = true;
    });
    if (widget.showOnlyStarSelected) {
      coursesOverviewFilter = coursesOverviewFilter
          .where((element) => element.isfavourite)
          .toList();
    }
    switch (widget.statusTypeSelected.key) {
      case CourseStatus.all:
        {
          if (!widget.showOnlyStarSelected)
            coursesOverviewFilter = coursesOverview;
          break;
        }
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
          if (!widget.showOnlyStarSelected)
            coursesOverviewFilter = coursesOverview;
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
    setState(() {
      isLoad = false;
    });
    return coursesOverviewFilter;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isFilter) {
      coursesOverview = coursesOverviewOld;
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
      child: isLoad
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
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
                  return CategoryView(
                    course: coursesOverview[index],
                    animation: animation,
                    animationController: animationController,
                  );
                },
              ),
            ),
    );
  }
}

class CategoryView extends StatelessWidget {
  const CategoryView(
      {Key? key, this.course, this.animationController, this.animation})
      : super(key: key);

  final CourseOverview? course;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation!.value), 0.0),
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: () => moveToCourseDetail(context, course!.id),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 0.0, top: 0.0, right: 0.0, bottom: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 5,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    gradient: const LinearGradient(
                        begin: Alignment.topRight,
                        stops: [0.1, 0.02],
                        colors: [MoodleColors.blue, Colors.white]),
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(
                        left: 26.0, top: 13.0, right: 10.0, bottom: 15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8, top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Flexible(
                                child: Text(
                                  '${course!.title}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      letterSpacing: 0.27,
                                      color: MoodleColors.black),
                                ),
                              ),
                              IconButton(
                                iconSize: 30,
                                icon: const Icon(Icons.more_vert),
                                color: MoodleColors.black,
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List<Widget>.generate(
                              course!.teacher.length,
                              (int index) {
                                final int count = course!.teacher.length;
                                final Animation<double> animation =
                                    Tween<double>(begin: 0.0, end: 1.0).animate(
                                  CurvedAnimation(
                                    parent: animationController!,
                                    curve: Interval((1 / count) * index, 1.0,
                                        curve: Curves.fastOutSlowIn),
                                  ),
                                );
                                animationController?.forward();
                                return Container(
                                  padding: const EdgeInsets.only(
                                      left: 0.0,
                                      top: 0.0,
                                      right: 0.0,
                                      bottom: 8.0),
                                  child: Text(
                                    'Teacher: ' +
                                        course!.teacher[index].fullname,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 13,
                                        letterSpacing: 0.27,
                                        color: MoodleColors.black),
                                  ),
                                );
                              },
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void moveToCourseDetail(BuildContext context, int id) {
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => CourseDetailsScreen(courseId: id),
      ),
    );
  }
}
