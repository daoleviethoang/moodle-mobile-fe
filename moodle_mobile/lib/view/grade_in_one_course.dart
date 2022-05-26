import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/constants/dimens.dart';
import 'package:moodle_mobile/data/network/apis/assignment/assignment_api.dart';
import 'package:moodle_mobile/models/assignment/assignment.dart';
import 'package:moodle_mobile/store/user/user_store.dart';

class GradeInOneCourse extends StatefulWidget {
  final int courseId;
  final String? courseName;
  const GradeInOneCourse(
      {Key? key, required this.courseId, required this.courseName})
      : super(key: key);

  @override
  State<GradeInOneCourse> createState() => _GradeInOneCourseState();
}

class _GradeInOneCourseState extends State<GradeInOneCourse> {
  late UserStore _userStore;
  List<Assignment> assignments = [];
  bool isLoad = true;

  @override
  void initState() {
    super.initState();
    _userStore = GetIt.instance<UserStore>();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return isLoad
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(Dimens.default_padding * 3),
                child: Text(widget.courseName!,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        letterSpacing: 1,
                        color: MoodleColors.black)),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(bottom: Dimens.default_padding * 3),
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.all(
                          Radius.circular(Dimens.default_border_radius * 3))),
                  child: Text("_",
                      style: TextStyle(
                          fontSize: 18,
                          letterSpacing: 1,
                          color: MoodleColors.white)),
                  padding: EdgeInsets.only(
                      top: Dimens.default_padding,
                      bottom: Dimens.default_padding,
                      left: Dimens.default_padding * 3,
                      right: Dimens.default_padding * 3),
                ),
              ),
              Divider(
                height: 10,
                thickness: 2,
              ),
              ListView(
                  shrinkWrap: true, //height is fit to children
                  physics: NeverScrollableScrollPhysics(),
                  children: List<Widget>.generate(
                    assignments.length,
                    (int index) => ListTile(
                      onTap: () {},
                      leading: const Icon(Icons.description),
                      title: Text(assignments[index].name!),
                      trailing: Text("-"),
                    ),
                  )),
            ]),
          );
  }

  getData() async {
    try {
      List<Assignment> getAssignments = await AssignmentApi()
          .getAssignments(_userStore.user.token, 0, widget.courseId);

      setState(() {
        assignments = getAssignments;
        isLoad = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
    }
  }
}
