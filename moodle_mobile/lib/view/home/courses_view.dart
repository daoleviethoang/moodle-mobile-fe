import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/constants/dimens.dart';
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
  bool isFilter;

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

  late UserStore _userStore;
  final int _caseMore = 0;
  bool isLoadFilter = false;
  bool isLoad = false;

  callback(caseMore, int id, bool value) {
    if (caseMore == 1) {
      coursesOverview.firstWhere((element) => element.id == id).isfavourite =
          value;
    } else if (caseMore == 2) {
      coursesOverview.firstWhere((element) => element.id == id).hidden = value;
    } else if (caseMore == 3) {}
    setState(() {
      coursesOverview = coursesOverview;
    });
  }

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    _userStore = GetIt.instance<UserStore>();
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isFilter) {
      List<CourseOverview> newCourseOverview = filterCourseHomePage();
      if (isLoadFilter == false) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      if (newCourseOverview.isEmpty) {
        return Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.notifications_none, size: 50),
            const Padding(padding: EdgeInsets.all(20)),
            Text(
              AppLocalizations.of(context)!.search_empty,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 0.27,
                  color: MoodleColors.black),
            ),
          ],
        ));
      } else {
        if (kDebugMode) {
          print("zo5");
        }
        coursesOverview = newCourseOverview;
      }
    }

    return isLoad
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
            padding: const EdgeInsets.only(left: 0, top: 50),
            child: RefreshIndicator(
              onRefresh: () => getData(),
              child: ListView(
                padding: const EdgeInsets.all(8),
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                children: List.generate(
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
                    return coursesOverview[index].hidden == false ||
                            widget.statusTypeSelected.key ==
                                CourseStatus.removed_from_view
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CategoryView(
                              course: coursesOverview[index],
                              animation: animation,
                              animationController: animationController,
                              userStore: _userStore,
                              callback: callback,
                            ),
                          )
                        : Container();
                  },
                ),
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
        if (coursesOverview.where((e) => element.id == e.id).isNotEmpty) {
          setState(() {
            coursesOverview.where((e) => element.id == e.id).first.teacher =
                contacts;
          });
        }
        if (element.id == courses[courses.length - 1].id) {
          isLoadFilter = true;
        }
      }
      coursesOverviewOld.addAll(coursesOverview);
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
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
      case CourseStatus.all:
        {
          coursesOverviewFilter = coursesOverviewFilter
              .where((element) => !element.hidden)
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

class CategoryView extends StatelessWidget {
  CategoryView(
      {Key? key,
      this.course,
      this.animationController,
      this.animation,
      this.userStore,
      this.callback})
      : super(key: key);

  final CourseOverview? course;
  final AnimationController? animationController;
  final Animation<double>? animation;
  final UserStore? userStore;
  Function? callback;

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
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0)),
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
                                  onPressed: () {
                                    showModalBottomSheet(
                                        context: context,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        builder: (builder) => buildBottomDialog(
                                            course!, builder));
                                  },
                                ),
                              ],
                            ),
                          ),
                          IntrinsicHeight(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: List<Widget>.generate(
                                      course!.teacher.length,
                                      (int index) {
                                        final int count =
                                            course!.teacher.length;
                                        final Animation<double> animation =
                                            Tween<double>(begin: 0.0, end: 1.0)
                                                .animate(
                                          CurvedAnimation(
                                            parent: animationController!,
                                            curve: Interval(
                                                (1 / count) * index, 1.0,
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
                                    ),
                                  ),
                                ),
                                course!.isfavourite
                                    ? const Padding(
                                        padding: EdgeInsets.only(right: 10),
                                        child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: Icon(
                                            Icons.star,
                                            size: 30,
                                            color: MoodleColors.yellow_icon,
                                          ),
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
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

  Widget buildBottomDialog(CourseOverview course, BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 20, left: 10, right: 10),
      decoration: const BoxDecoration(
        color: MoodleColors.grey_bottom_bar,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Dimens.default_sheet_radius),
          topRight: Radius.circular(Dimens.default_sheet_radius),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            height: 5,
            width: 134,
            decoration: const BoxDecoration(
              color: MoodleColors.line_bottom_bar,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
          ),
          removeOrRestoreCourse(course, context),
          starOrUnStarCourse(course, context),
          downloadCourse(context),
        ],
      ),
    );
  }

  Widget removeOrRestoreCourse(
      CourseOverview courseSelectedMore, BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: MoodleColors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: courseSelectedMore.hidden
          ? Padding(
              padding:
                  const EdgeInsets.only(left: 30, bottom: 5, top: 5, right: 30),
              child: TextButton.icon(
                onPressed: () async {
                  await CourseService().setUnHiddenCourse(
                    userStore!.user.token,
                    courseSelectedMore.id,
                  );
                  callback!(2, courseSelectedMore.id, false);
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.restore_outlined,
                  color: MoodleColors.black,
                  size: 30,
                ),
                label: const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "Restore to view",
                    style: TextStyle(color: MoodleColors.black, fontSize: 16),
                  ),
                ),
                style: TextButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  primary: MoodleColors.white,
                ),
              ),
            )
          : Padding(
              padding:
                  const EdgeInsets.only(left: 30, bottom: 5, top: 5, right: 30),
              child: TextButton.icon(
                onPressed: () async {
                  await CourseService().setHiddenCourse(
                    userStore!.user.token,
                    courseSelectedMore.id,
                  );
                  callback!(2, courseSelectedMore.id, true);
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.remove_red_eye_outlined,
                  color: MoodleColors.black,
                  size: 30,
                ),
                label: const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "Remove from view",
                    style: TextStyle(color: MoodleColors.black, fontSize: 16),
                  ),
                ),
                style: TextButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  primary: MoodleColors.white,
                ),
              ),
            ),
    );
  }

  Widget starOrUnStarCourse(
      CourseOverview courseSelectedMore, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 13, bottom: 13),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: MoodleColors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: courseSelectedMore.isfavourite
          ? Padding(
              padding:
                  const EdgeInsets.only(left: 28, bottom: 5, top: 5, right: 30),
              child: TextButton.icon(
                onPressed: () async {
                  await CourseService().setFavouriteCourse(
                    userStore!.user.token,
                    courseSelectedMore.id,
                    0,
                  );
                  callback!(1, courseSelectedMore.id, false);
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.star_border_rounded,
                  color: MoodleColors.yellow_icon,
                  size: 30,
                ),
                label: const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "Unstar this course",
                    style: TextStyle(color: MoodleColors.black, fontSize: 16),
                  ),
                ),
                style: TextButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  primary: MoodleColors.white,
                ),
              ),
            )
          : Padding(
              padding:
                  const EdgeInsets.only(left: 28, bottom: 5, top: 5, right: 30),
              child: TextButton.icon(
                onPressed: () async {
                  await CourseService().setFavouriteCourse(
                    userStore!.user.token,
                    courseSelectedMore.id,
                    1,
                  );
                  callback!(1, courseSelectedMore.id, true);
                  Navigator.pop(context);
                },
                icon: Container(
                    decoration: const BoxDecoration(
                        color: MoodleColors.border_star,
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    child: const Padding(
                      padding: EdgeInsets.all(5),
                      child: Icon(
                        Icons.star,
                        color: MoodleColors.yellow_icon,
                        size: 25,
                      ),
                    )),
                label: const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "Star this course",
                    style: const TextStyle(
                        color: MoodleColors.black, fontSize: 16),
                  ),
                ),
                style: TextButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  primary: MoodleColors.white,
                ),
              ),
            ),
    );
  }

  Widget downloadCourse(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: MoodleColors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 30, bottom: 5, top: 5, right: 30),
        child: TextButton.icon(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.file_download_outlined,
            color: MoodleColors.black,
            size: 30,
          ),
          label: const Padding(
            padding: const EdgeInsets.only(left: 20),
            child: const Text(
              "Download courses",
              style: TextStyle(color: MoodleColors.black, fontSize: 16),
            ),
          ),
          style: TextButton.styleFrom(
            alignment: Alignment.centerLeft,
            primary: MoodleColors.white,
          ),
        ),
      ),
    );
  }
}
