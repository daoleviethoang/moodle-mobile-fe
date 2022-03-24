import 'package:moodle_mobile/models/category.dart';
import 'package:flutter/material.dart';
import 'package:moodle_mobile/view/home/courses_view.dart';

import '../../constants/colors.dart';

class CategoryCourseListView extends StatefulWidget {
  List<Course> courses;
  CategoryCourseListView({Key? key, this.callBack, required this.courses})
      : super(key: key);

  final Function()? callBack;
  @override
  _CategoryCourseListViewState createState() => _CategoryCourseListViewState();
}

class _CategoryCourseListViewState extends State<CategoryCourseListView>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0),
      child: FutureBuilder<bool>(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          } else {
            return ListView(
              padding: const EdgeInsets.all(8),
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: List<Widget>.generate(
                widget.courses.length,
                (int index) {
                  final int count = widget.courses.length;
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
                    category: widget.courses[index],
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
