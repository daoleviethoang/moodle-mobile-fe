import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:flutter_html/flutter_html.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/data/network/apis/assignment/assignment_api.dart';
import 'package:moodle_mobile/data/network/apis/quiz/quiz_api.dart';
import 'package:moodle_mobile/models/assignment/assignment.dart';
import 'package:moodle_mobile/models/assignment/attemp_assignment.dart';
import 'package:moodle_mobile/models/quiz/attempt.dart';
import 'package:moodle_mobile/models/quiz/quiz.dart';
import 'package:moodle_mobile/models/quiz/quiz_module.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/assignment/date_assignment_tile.dart';
import 'package:moodle_mobile/view/assignment/files_assignment.dart';
import 'package:moodle_mobile/view/assignment/submission_status_tile.dart';
import 'package:moodle_mobile/view/common/custom_button.dart';
import 'package:moodle_mobile/view/common/custom_button_short.dart';

class QuizScreen extends StatefulWidget {
  final int quizInstanceId;
  final int courseId;
  final String title;
  const QuizScreen({
    Key? key,
    required this.quizInstanceId,
    required this.courseId,
    required this.title,
  }) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  bool isLoading = false;
  late UserStore _userStore;
  Quiz quiz = Quiz();
  Attempt lastAttempt = Attempt();
  var dayOfWeek = DateFormat("EEE,");
  var formatDate = DateFormat("dd MMM yyyy, hh:mmaa");
  double? grade;

  @override
  void initState() {
    _userStore = GetIt.instance<UserStore>();
    super.initState();
    load();
  }

  void load() async {
    setState(() {
      isLoading = true;
    });
    try {
      List<Quiz> quizes =
          await QuizApi().getQuizs(_userStore.user.token, widget.courseId);
      for (var item in quizes) {
        if (item.id == widget.quizInstanceId) {
          setState(() {
            quiz = item;
          });
          break;
        }
      }
      List<Attempt> attemps = await QuizApi()
          .getAttempts(_userStore.user.token, widget.quizInstanceId);
      if (attemps.isNotEmpty) {
        Attempt temp = attemps.first;
        for (var item in attemps) {
          if ((item.timefinish ?? 0) > (temp.timefinish ?? 0)) {
            temp = item;
          }
        }
        setState(() {
          lastAttempt = temp;
        });
      }
      double? temp2 = await QuizApi()
          .getGrade(_userStore.user.token, widget.quizInstanceId);
      setState(() {
        grade = temp2;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            snap: true,
            title: Text(
              widget.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            leading: TextButton(
              style: TextButton.styleFrom(
                primary: Colors.white,
              ),
              child: const Icon(CupertinoIcons.back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DateAssignmentTile(
                        date: (quiz.timeopen ?? 0) * 1000,
                        title: "Opened",
                        iconColor: Colors.grey,
                        backgroundIconColor:
                            const Color.fromARGB(255, 217, 217, 217),
                      ),
                      DateAssignmentTile(
                        date: (quiz.timeclose ?? 0) * 1000,
                        title: "Due",
                        iconColor: Colors.green,
                        backgroundIconColor: Colors.greenAccent,
                      ),
                      const Divider(),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            Text('Attempts allowed: ${quiz.attempts ?? 0}'),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                                "Time limit: ${(quiz.timelimit ?? 0) / 60} mins"),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Card(
                        child: Html(
                          data: quiz.intro ?? "",
                          shrinkWrap: true,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        "Summary of your previous attempts",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          left: 20,
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Expanded(
                                child: Text(
                              "State",
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textScaleFactor: 1.1,
                            )),
                            Expanded(
                              child: Center(
                                child: Text(
                                  "Grade/10",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textScaleFactor: 1.1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          left: 20,
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            ((quiz.timeclose ?? 0 * 1000) <
                                    DateTime.now().millisecondsSinceEpoch)
                                ? Expanded(
                                    child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      const Text(
                                        "Finished",
                                        style: TextStyle(
                                            color: MoodleColors.blue,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text("Submitted " +
                                          dayOfWeek.format(DateTime
                                              .fromMillisecondsSinceEpoch(
                                                  (lastAttempt.timefinish ??
                                                          0) *
                                                      1000))),
                                      Text(formatDate.format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              (lastAttempt.timefinish ?? 0) *
                                                  1000))),
                                    ],
                                  ))
                                : Expanded(
                                    child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: const [
                                      Text(
                                        "Unfinished",
                                        style: TextStyle(
                                            color: MoodleColors.blue,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(""),
                                      Text(""),
                                    ],
                                  )),
                            Expanded(
                                child: Center(
                                    child: Text(grade?.toStringAsFixed(2) ??
                                        "Not Grade"))),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 5,
                      ),
                      ((quiz.timeclose ?? 0 * 1000) <
                              DateTime.now().millisecondsSinceEpoch)
                          ? Center(
                              child: CustomButtonShort(
                                text: "Preview",
                                onPressed: () {},
                                bgColor: MoodleColors.blue,
                                blurRadius: 0,
                                textColor: Colors.white,
                              ),
                            )
                          : Center(
                              child: CustomButtonShort(
                                text: "Attempt quiz now",
                                onPressed: () {},
                                bgColor: MoodleColors.blue,
                                blurRadius: 0,
                                textColor: Colors.white,
                              ),
                            ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}