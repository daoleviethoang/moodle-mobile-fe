import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/data/network/apis/contact/contact_service.dart';
import 'package:moodle_mobile/data/network/apis/course/course_service.dart';
import 'package:moodle_mobile/models/contact/contact.dart';
import 'package:moodle_mobile/models/course/course.dart';
import 'package:moodle_mobile/models/course/courses.dart';
import 'package:moodle_mobile/store/user/user_store.dart';

import '../../constants/colors.dart';

class PopularCourseListView extends StatefulWidget {
  const PopularCourseListView({Key? key, this.callBack}) : super(key: key);

  final Function()? callBack;
  @override
  _PopularCourseListViewState createState() => _PopularCourseListViewState();
}

class _PopularCourseListViewState extends State<PopularCourseListView>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<CourseOverview> coursesOverview = [];
  late UserStore _userStore;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    _userStore = GetIt.instance<UserStore>();
    super.initState();
    loadCourse();
    setState(() {});
  }

  Future<List<CourseOverview>> getData() async {
    try {
      List<Course> courses = await CourseService()
          .getCourses(_userStore.user.token, _userStore.user.id);

      for (var element in courses) {
        List<Contact> contacts = await ContactService()
            .getContacts(_userStore.user.token, element.id);
        coursesOverview.add(CourseOverview(
            id: element.id, title: element.displayname, teacher: contacts));
      }
      return coursesOverview;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
    }
    return [];
  }

  void loadCourse() async {
    List<CourseOverview> coursesTemp = await getData();
    setState(() {
      coursesOverview = coursesTemp;
    });
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0),
      child: FutureBuilder<List<CourseOverview>>(
        future: getData(),
        builder: (context, data) {
          List<CourseOverview> coursesOverview = [];
          if (!data.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            List<CourseOverview> _courses = data.data as List<CourseOverview>;
            coursesOverview = _courses
                .map((e) => CourseOverview(
                    id: e.id, title: e.title, teacher: e.teacher))
                .toList();
            return ListView(
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
                    callback: widget.callBack,
                    course: coursesOverview[index],
                    animation: animation,
                    animationController: animationController,
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}

class CategoryView extends StatelessWidget {
  const CategoryView(
      {Key? key,
      this.course,
      this.animationController,
      this.animation,
      this.callback})
      : super(key: key);

  final VoidCallback? callback;
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
              onTap: callback,
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
                        const BorderRadius.all(const Radius.circular(8.0)),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(
                        left: 26.0, top: 13.0, right: 10.0, bottom: 15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
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
}
