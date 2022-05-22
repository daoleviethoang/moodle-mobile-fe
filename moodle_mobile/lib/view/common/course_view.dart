import 'package:flutter/material.dart';
import 'package:moodle_mobile/models/course/courses.dart';
import 'package:moodle_mobile/view/course_details.dart';

import '../../constants/colors.dart';

class CourseView extends StatefulWidget {
  final CourseOverview? course;
  final AnimationController? animationController;
  final Animation<double>? animation;
  final Function(CourseOverview courseSelected) onCourseMoreSelected;

  CourseView(this.course, this.animationController, this.animation,
      this.onCourseMoreSelected,
      {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _CourseViewState(course, animationController, animation);
}

class _CourseViewState extends State<CourseView> {
  final CourseOverview? course;
  final AnimationController? animationController;
  final Animation<double>? animation;

  _CourseViewState(this.course, this.animationController, this.animation);

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
                                focusColor: MoodleColors.blueDark,
                                onPressed: () {
                                  widget.onCourseMoreSelected(course!);
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List<Widget>.generate(
                                  course!.teacher.length,
                                  (int index) {
                                    final int count = course!.teacher.length;
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
