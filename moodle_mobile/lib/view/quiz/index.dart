import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/data/network/apis/contact/contact_service.dart';
import 'package:moodle_mobile/data/network/apis/quiz/quiz_api.dart';
import 'package:moodle_mobile/models/assignment/user_submited.dart';
import 'package:moodle_mobile/models/contact/contact.dart';
import 'package:moodle_mobile/models/quiz/attempt.dart';
import 'package:moodle_mobile/models/quiz/quiz.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/assignment/date_assignment_tile.dart';
import 'package:moodle_mobile/view/assignment/list_user_submit.dart';
import 'package:moodle_mobile/view/common/content_item.dart';
import 'package:moodle_mobile/view/common/custom_button_short.dart';
import 'package:moodle_mobile/view/quiz/do_quiz/do_quiz.dart';
import 'package:moodle_mobile/view/quiz/preview/preview_quiz.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moodle_mobile/view/quiz/teacher_quiz/participant_quiz.dart';

class QuizScreen extends StatefulWidget {
  final int quizInstanceId;
  final int courseId;
  final String title;
  final bool? isTeacher;
  const QuizScreen({
    Key? key,
    required this.quizInstanceId,
    required this.courseId,
    required this.title,
    required this.isTeacher,
  }) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  bool isLoading = false;
  late UserStore _userStore;
  Quiz quiz = Quiz();
  Attempt lastAttempt = Attempt();
  int numAttempt = 0;
  var dayOfWeek = DateFormat("EEE,");
  var formatDate = DateFormat("dd MMM yyyy, hh:mmaa");
  double? grade;
  bool isTeacher = false;
  List<Attempt> attemps = [];
  @override
  void initState() {
    _userStore = GetIt.instance<UserStore>();
    super.initState();
    if (widget.isTeacher != null) {
      isTeacher = widget.isTeacher!;
    } else {
      checkIsTeacher();
    }
    load();
  }

  checkIsTeacher() async {
    List<Contact> contacts = await ContactService()
        .getContacts(_userStore.user.token, widget.courseId);
    if (contacts.any((element) => element.id == _userStore.user.id)) {
      setState(() {
        isTeacher = true;
      });
    }
  }

  load() async {
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

      attemps = await QuizApi()
          .getAttempts(_userStore.user.token, widget.quizInstanceId);
      setState(() {
        numAttempt = attemps.length;
      });

      if (attemps.isNotEmpty) {
        Attempt temp = attemps.first;
        for (var item in attemps) {
          if ((item.timestart ?? 0) > (temp.timestart ?? 0)) {
            temp = item;
          }
        }
        setState(() {
          lastAttempt = temp;
        });
        //print(lastAttempt.state);
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
                      quiz.timeopen == null
                          ? Container()
                          : DateAssignmentTile(
                              date: (quiz.timeopen ?? 0) * 1000,
                              title: AppLocalizations.of(context)!.opened,
                              iconColor: Colors.grey,
                              backgroundIconColor:
                                  const Color.fromARGB(255, 217, 217, 217),
                            ),
                      quiz.timeclose == null
                          ? Container()
                          : DateAssignmentTile(
                              date: (quiz.timeclose ?? 0) * 1000,
                              title: AppLocalizations.of(context)!.due,
                              iconColor: Colors.green,
                              backgroundIconColor: Colors.greenAccent,
                            ),
                      const LineItem(
                        width: 0.8,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            quiz.attempts == 0
                                ? Text(AppLocalizations.of(context)!
                                        .attempt_allow +
                                    " " +
                                    AppLocalizations.of(context)!.unlimit)
                                : Text(AppLocalizations.of(context)!
                                        .attempt_allow +
                                    " ${quiz.attempts ?? 0}"),
                            const SizedBox(
                              height: 20,
                            ),
                            quiz.timelimit == 0
                                ? Text(
                                    AppLocalizations.of(context)!.time_limit +
                                        " " +
                                        AppLocalizations.of(context)!.unlimit)
                                : Text(
                                    AppLocalizations.of(context)!.time_limit +
                                        " ${(quiz.timelimit ?? 0) / 60} " +
                                        AppLocalizations.of(context)!.minutes),
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
                      isTeacher
                          ? Column(
                              children: <Widget>[
                                const LineItem(
                                  width: 0.8,
                                ),
                                ListTile(
                                    onTap: numAttempt == 0
                                        ? null
                                        : () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(builder: (_) {
                                              return ParticipantQuiz(
                                                quizInstanceId:
                                                    widget.quizInstanceId,
                                                quizName: widget.title,
                                                attemps: attemps,
                                              );
                                            }));
                                          },
                                    title: Text(AppLocalizations.of(context)!
                                        .number_student),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 10, 0),
                                          child: Text(numAttempt.toString()),
                                        ),
                                        Icon(
                                          Icons.keyboard_arrow_right_rounded,
                                          size: 25.0,
                                          color: Colors.brown[900],
                                        ),
                                      ],
                                    )),
                              ],
                            )
                          : Column(
                              children: <Widget>[
                                Text(
                                  AppLocalizations.of(context)!.summary_attempt,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                          child: Text(
                                        AppLocalizations.of(context)!.state,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                        textScaleFactor: 1.1,
                                      )),
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                    .grade +
                                                "/10",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
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
                                      lastAttempt.state == "finished"
                                          ? Expanded(
                                              child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .finished,
                                                  style: const TextStyle(
                                                      color: MoodleColors.blue,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                if (lastAttempt.id != null)
                                                  Text(AppLocalizations.of(
                                                              context)!
                                                          .submitted +
                                                      " " +
                                                      dayOfWeek.format(DateTime
                                                          .fromMillisecondsSinceEpoch(
                                                              (lastAttempt.timefinish ??
                                                                      0) *
                                                                  1000))),
                                                if (lastAttempt.id != null)
                                                  Text(formatDate.format(DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                          (lastAttempt.timefinish ??
                                                                  0) *
                                                              1000))),
                                              ],
                                            ))
                                          : Expanded(
                                              child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                const Text(""),
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .unfinished,
                                                  style: const TextStyle(
                                                      color: MoodleColors.blue,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                const Text(""),
                                              ],
                                            )),
                                      Expanded(
                                          child: Center(
                                              child: Text(grade
                                                      ?.toStringAsFixed(2) ??
                                                  AppLocalizations.of(context)!
                                                      .not_graded))),
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
                                if (lastAttempt.id != null &&
                                    lastAttempt.state == "finished" &&
                                    lastAttempt.preview == 0)
                                  Center(
                                    child: CustomButtonShort(
                                      text: AppLocalizations.of(context)!
                                          .preview_last,
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(builder: (_) {
                                          return QuizPreviewScreen(
                                            title: widget.title,
                                            attemptId: lastAttempt.id ?? 0,
                                          );
                                        }));
                                      },
                                      bgColor: MoodleColors.blue,
                                      blurRadius: 0,
                                      textColor: Colors.white,
                                    ),
                                  ),
                                const SizedBox(
                                  height: 15,
                                ),
                                if (lastAttempt.state == "finished" &&
                                        ((quiz.attempts ?? 0) > numAttempt) ||
                                    quiz.attempts == 0)
                                  Center(
                                    child: CustomButtonShort(
                                      text: AppLocalizations.of(context)!
                                          .start_attempt,
                                      onPressed: () async {
                                        Attempt attempt = await QuizApi()
                                            .startQuiz(_userStore.user.token,
                                                widget.quizInstanceId);
                                        Navigator.of(context).push(
                                            MaterialPageRoute(builder: (_) {
                                          return QuizDoScreen(
                                            title: widget.title,
                                            attemptId: attempt.id ?? 0,
                                            endTime: quiz.timelimit == 0
                                                ? 0
                                                : DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            (attempt.timestart ??
                                                                    0) *
                                                                1000)
                                                    .add(Duration(
                                                        seconds:
                                                            quiz.timelimit ??
                                                                0))
                                                    .millisecondsSinceEpoch,
                                          );
                                        })).then((value) async {
                                          await load();
                                        });
                                      },
                                      bgColor: MoodleColors.blue,
                                      blurRadius: 0,
                                      textColor: Colors.white,
                                    ),
                                  ),
                                const SizedBox(
                                  height: 10,
                                ),
                                if (lastAttempt.state == "inprogress")
                                  Center(
                                    child: CustomButtonShort(
                                      text: AppLocalizations.of(context)!
                                          .continue_attempt,
                                      onPressed: () async {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(builder: (_) {
                                          return QuizDoScreen(
                                            title: widget.title,
                                            attemptId: lastAttempt.id ?? 0,
                                            endTime: quiz.timelimit == 0
                                                ? 0
                                                : DateTime.fromMillisecondsSinceEpoch(
                                                        (lastAttempt.timestart ??
                                                                0) *
                                                            1000)
                                                    .add(Duration(
                                                        seconds:
                                                            quiz.timelimit ??
                                                                0))
                                                    .millisecondsSinceEpoch,
                                          );
                                        })).then((value) async {
                                          await load();
                                        });
                                      },
                                      bgColor: MoodleColors.blue,
                                      blurRadius: 0,
                                      textColor: Colors.white,
                                    ),
                                  ),
                              ],
                            )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
