import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/data/network/apis/course/course_service.dart';
import 'package:moodle_mobile/models/course/courses.dart';
import 'package:moodle_mobile/store/user/user_store.dart';

class HomeBottomBar extends StatefulWidget {
  final CourseOverview _courseSelectedMore;
  final bool _isSelectedMoreOption;

  final Function(
          CourseOverview? courseSelectedMore, bool? _isSelectedMoreOption)
      onCourseMoreSelected;

  const HomeBottomBar(this._courseSelectedMore, this.onCourseMoreSelected,
      this._isSelectedMoreOption,
      {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _HomeBottomBarState(_courseSelectedMore, _isSelectedMoreOption);
}

class _HomeBottomBarState extends State<HomeBottomBar>
    with SingleTickerProviderStateMixin {
  CourseOverview courseSelectedMore;
  bool isSelectedMoreOption;

  late AnimationController expandController;
  late Animation<double> animation;
  late UserStore _userStore;

  _HomeBottomBarState(this.courseSelectedMore, this.isSelectedMoreOption);

  @override
  void initState() {
    super.initState();
    expandController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
    _runExpandCheck();
    _userStore = GetIt.instance<UserStore>();
  }

  void _runExpandCheck() {
    if (courseSelectedMore != null) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (courseSelectedMore != null) {
      print(courseSelectedMore.title);
    }
    return buildMyNavBar(context);
  }

  Stack buildMyNavBar(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
            onTap: () {
              widget.onCourseMoreSelected(null, false);
              _runExpandCheck();
            },
            child: SizeTransition(
              axisAlignment: 1.0,
              sizeFactor: animation,
              child: Container(
                color: MoodleColors.black.withOpacity(0.2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                          top: 8, bottom: 20, left: 10, right: 10),
                      decoration: const BoxDecoration(
                        color: MoodleColors.grey_bottom_bar,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 20),
                            height: 5,
                            width: 134,
                            decoration: const BoxDecoration(
                              color: MoodleColors.line_bottom_bar,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                          ),
                          removeOrRestoreCourse(),
                          starOrUnStarCourse(),
                          downloadCourse(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Widget removeOrRestoreCourse() {
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
                onPressed: () {
                  widget.onCourseMoreSelected(null, true);
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
                onPressed: () {
                  widget.onCourseMoreSelected(null, true);
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

  Widget starOrUnStarCourse() {
    return Container(
      margin: EdgeInsets.only(top: 13, bottom: 13),
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
                    _userStore.user.token,
                    courseSelectedMore.id,
                    0,
                  );
                  widget.onCourseMoreSelected(null, true);
                },
                icon: Container(
                  decoration: const BoxDecoration(
                      color: MoodleColors.border_star,
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                  child: const Padding(
                    padding: EdgeInsets.all(5),
                    child: Icon(
                      Icons.star,
                      color: MoodleColors.red_error_message,
                      size: 25,
                    ),
                  ),
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
                    _userStore.user.token,
                    courseSelectedMore.id,
                    1,
                  );
                  widget.onCourseMoreSelected(null, true);
                },
                icon: Container(
                    decoration: const BoxDecoration(
                        color: MoodleColors.border_star,
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Icon(
                        Icons.star,
                        color: MoodleColors.yellow_icon,
                        size: 25,
                      ),
                    )),
                label: Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "Star this course",
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

  Widget downloadCourse() {
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
            widget.onCourseMoreSelected(null, true);
          },
          icon: const Icon(
            Icons.file_download_outlined,
            color: MoodleColors.black,
            size: 30,
          ),
          label: Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
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
