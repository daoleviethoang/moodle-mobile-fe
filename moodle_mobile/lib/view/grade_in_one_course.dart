import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/data/network/apis/assignment/assignment_api.dart';
import 'package:moodle_mobile/data/network/apis/course/course_service.dart';
import 'package:moodle_mobile/data/network/apis/quiz/quiz_api.dart';
import 'package:moodle_mobile/models/assignment/assignment.dart';
import 'package:moodle_mobile/models/assignment/feedback.dart';
import 'package:moodle_mobile/models/quiz/quiz.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/common/course/grade_overview.dart';

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
              GradeOverview(
                courseId: widget.courseId,
                courseName: widget.courseName,
                courseGrade: courseGrade,
              ),
              ListView(
                  padding: const EdgeInsets.only(top: 0),
                  shrinkWrap: true, //height is fit to children
                  physics: const NeverScrollableScrollPhysics(),
                  children: List<Widget>.generate(
                    assignments.length,
                    (int index) => ListTile(
                      onTap: null,
                      leading: const Icon(Icons.description),
                      title: Text(assignments[index].name!),
                      trailing: index < gradesAssign.length
                          ? Text(gradesAssign[index] ?? "-")
                          : const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(),
                            ),
                    ),
                  )),
              ListView(
                  padding: const EdgeInsets.only(top: 0),
                  shrinkWrap: true, //height is fit to children
                  physics: const NeverScrollableScrollPhysics(),
                  children: List<Widget>.generate(
                    quizs.length,
                    (int index) => ListTile(
                      onTap: null,
                      leading: const Icon(Icons.description),
                      title: Text(quizs[index].name!),
                      trailing: index < gradesQuiz.length
                          ? Text(gradesQuiz[index]?.toString() ?? "-")
                          : const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(),
                            ),
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

      List<Quiz> getQuizs =
          await QuizApi().getQuizs(_userStore.user.token, widget.courseId);

      setState(() {
        assignments = getAssignments;
        quizs = getQuizs;
        isLoad = false;
      });

      for (var item in getAssignments) {
        FeedBack feedBack = await AssignmentApi()
            .getAssignmentFeedbackAndGrade(_userStore.user.token, item.id ?? 0);
        setState(() {
          gradesAssign.add(feedBack.grade?.grade);
        });
      }

      for (var item in getQuizs) {
        double? grade =
            await QuizApi().getGrade(_userStore.user.token, item.id ?? 0);
        setState(() {
          gradesQuiz.add(grade);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
    }
  }
}