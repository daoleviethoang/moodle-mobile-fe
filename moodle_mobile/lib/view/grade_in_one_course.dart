import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/constants/dimens.dart';
import 'package:moodle_mobile/data/network/apis/assignment/assignment_api.dart';
import 'package:moodle_mobile/data/network/apis/course/course_service.dart';
import 'package:moodle_mobile/data/network/apis/quiz/quiz_api.dart';
import 'package:moodle_mobile/models/assignment/assignment.dart';
import 'package:moodle_mobile/models/assignment/feedback.dart';
import 'package:moodle_mobile/models/quiz/quiz.dart';
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
  String? courseGrade;
  List<Assignment> assignments = [];
  List<String?> gradesAssign = [];
  List<Quiz> quizs = [];
  List<double?> gradesQuiz = [];
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
                  child: Text(courseGrade ?? "-",
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
                  padding: EdgeInsets.only(top: 0),
                  shrinkWrap: true, //height is fit to children
                  physics: NeverScrollableScrollPhysics(),
                  children: List<Widget>.generate(
                    assignments.length,
                    (int index) => ListTile(
                      onTap: () {},
                      leading: const Icon(Icons.description),
                      title: Text(assignments[index].name!),
                      trailing: Text(gradesAssign[index] ?? "-"),
                    ),
                  )),
              ListView(
                  padding: EdgeInsets.only(top: 0),
                  shrinkWrap: true, //height is fit to children
                  physics: NeverScrollableScrollPhysics(),
                  children: List<Widget>.generate(
                    quizs.length,
                    (int index) => ListTile(
                      onTap: () {},
                      leading: const Icon(Icons.description),
                      title: Text(quizs[index].name!),
                      trailing: Text(gradesQuiz[index]?.toString() ?? "-"),
                    ),
                  )),
            ]),
          );
  }

  getData() async {
    try {
      String? getGrade = await CourseService()
          .getGrade(_userStore.user.token, widget.courseId);

      setState(() {
        courseGrade = getGrade;
      });

      List<Assignment> getAssignments = await AssignmentApi()
          .getAssignments(_userStore.user.token, 0, widget.courseId);

      for (var item in getAssignments) {
        FeedBack feedBack = await AssignmentApi()
            .getAssignmentFeedbackAndGrade(_userStore.user.token, item.id ?? 0);
        setState(() {
          gradesAssign.add(feedBack.grade?.grade);
        });
      }

      List<Quiz> getQuizs =
          await QuizApi().getQuizs(_userStore.user.token, widget.courseId);

      for (var item in getQuizs) {
        double? grade =
            await QuizApi().getGrade(_userStore.user.token, item.id ?? 0);
        setState(() {
          gradesQuiz.add(grade);
        });
      }

      setState(() {
        assignments = getAssignments;
        quizs = getQuizs;
        isLoad = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
    }
  }
}
