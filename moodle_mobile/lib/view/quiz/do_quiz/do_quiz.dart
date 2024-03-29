import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/data/network/apis/quiz/quiz_api.dart';
import 'package:moodle_mobile/models/quiz/question.dart';
import 'package:moodle_mobile/models/quiz/quizData.dart';
import 'package:moodle_mobile/models/quiz/quiz_save.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/quiz/do_quiz/type/essay_do_quiz.dart';
import 'package:moodle_mobile/view/quiz/do_quiz/type/multi_choice_do_quiz.dart';
import 'package:moodle_mobile/view/quiz/do_quiz/type/number_do_quiz.dart';
import 'package:moodle_mobile/view/quiz/do_quiz/type/one_choice_do_quiz.dart';
import 'package:moodle_mobile/view/quiz/do_quiz/type/short_answer_do_quiz.dart';
import 'package:moodle_mobile/view/quiz/question_tile.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QuizDoScreen extends StatefulWidget {
  final int attemptId;
  final String title;
  final int endTime;
  const QuizDoScreen({
    Key? key,
    required this.attemptId,
    required this.title,
    required this.endTime,
  }) : super(key: key);

  @override
  _QuizDoScreenState createState() => _QuizDoScreenState();
}

class _QuizDoScreenState extends State<QuizDoScreen> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  bool isLoading = false;
  late UserStore _userStore;
  int page = 0;
  List<QuizSaveData> list = [];
  List<int> points = [];
  List<bool> complete = [];
  QuizData? quizData;
  bool error = false;
  bool finish = false;

  Future<bool> saveQuiz(int index) async {
    if (list[index].answers.isNotEmpty) {
      try {
        await QuizApi().saveQuizData(_userStore.user.token, widget.attemptId,
            list[index].answers, list[index].values);
        return true;
      } catch (e) {
        if (kDebugMode) {
          print(e);
          print(
              "Can't save quiz: ${list[index].answers} ${list[index].values}");
        }
      }
    }
    return false;
  }

  endQuiz() async {
    try {
      setState(() {
        finish = true;
      });
      await QuizApi().endQuiz(
        _userStore.user.token,
        widget.attemptId,
      );
    } catch (e) {
      setState(() {
        finish = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context)!.error),
        backgroundColor: Colors.red,
      ));
      if (kDebugMode) {
        print("Can't end quiz");
      }
    }
  }

  Future<bool> setDataSave(
      int index, List<String> answers, List<String> values) async {
    setState(() {
      list[index] = QuizSaveData(answers: answers, values: values);
    });
    return await saveQuiz(index);
  }

  setComplete(int index, bool value) {
    if (complete[index] != value) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => setState(
          () {
            complete[index] = value;
          },
        ),
      );
    }
  }

  @override
  void initState() {
    _userStore = GetIt.instance<UserStore>();
    load();
    super.initState();
  }

  void load() async {
    setState(() {
      isLoading = true;
    });
    try {
      var temp = await QuizApi()
          .getDoQuizData(_userStore.user.token, widget.attemptId);
      setState(() {
        quizData = temp;
      });

      setState(() {
        list = quizData?.questions
                ?.map((e) => QuizSaveData(answers: [], values: []))
                .toList() ??
            [];
        points = quizData?.questions?.map((e) => e.maxmark ?? 1).toList() ?? [];
        complete = quizData?.questions?.map((e) => false).toList() ?? [];
      });

      checkTypeQuiz();
    } catch (e) {
      setState(() {
        error = true;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<bool> showDialogFinish() async {
    bool check = false;
    await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.fromLTRB(50, 30, 50, 10),
          title: const Text(
            'Are you want to finish quiz?',
            textScaleFactor: 0.8,
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          actions: [
            Row(children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      )),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(MoodleColors.grey),
                      shape: MaterialStateProperty.all(
                          const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))))),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    check = true;
                    Navigator.pop(context);
                  },
                  child: const Text("Submit",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      )),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(MoodleColors.blue),
                      shape: MaterialStateProperty.all(
                          const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))))),
                ),
              ),
            ]),
          ],
        );
      },
    );
    return check;
  }

  checkTypeQuiz() {
    List<Question> list = quizData?.questions ?? [];
    bool check = list.every(
      (question) {
        if (question.type == "multichoice") return true;
        if (question.type == "essay") return true;
        if (question.type == "numerical") return true;
        if (question.type == "shortanswer") return true;
        return false;
      },
    );
    if (check == false) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.quiz_type_dont_support),
          backgroundColor: Colors.red));
    }
  }

  _buildMainContent() {
    return NestedScrollView(
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
          : error
              ? const Center(
                  child: Text("Error loading"),
                )
              : Container(
                  padding: const EdgeInsets.only(
                    bottom: 50,
                  ),
                  margin: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 20,
                  ),
                  child: ScrollablePositionedList.builder(
                    shrinkWrap: true,
                    itemCount: quizData?.questions?.length ?? 0,
                    itemBuilder: (context, index) {
                      Question question =
                          quizData?.questions?[index] ?? Question();
                      int uniqueId = quizData?.attempt?.uniqueid ?? 0;
                      int slot = question.slot ?? 0;
                      if (question.type == "multichoice") {
                        if (question.html
                                ?.contains("q$uniqueId:$slot" "_choice0") ??
                            false) {
                          return QuestionTile(
                              content: MultiChoiceDoQuiz(
                                uniqueId: uniqueId,
                                slot: slot,
                                html: question.html ?? "",
                                index: index,
                                token: _userStore.user.token,
                                setData: setDataSave,
                                setComplete: setComplete,
                                sequenceCheck: question.sequencecheck ?? 0,
                              ),
                              question: question,
                              index: question.number ?? 1);
                        } else {
                          return QuestionTile(
                              content: OneChoiceDoQuiz(
                                uniqueId: uniqueId,
                                slot: slot,
                                html: question.html ?? "",
                                index: index,
                                token: _userStore.user.token,
                                setData: setDataSave,
                                setComplete: setComplete,
                                sequenceCheck: question.sequencecheck ?? 0,
                              ),
                              question: question,
                              index: question.number ?? 1);
                        }
                      }
                      if (question.type == "essay") {
                        return QuestionTile(
                            content: Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: EssayDoQuiz(
                                uniqueId: uniqueId,
                                slot: slot,
                                index: index,
                                html: question.html ?? "",
                                token: _userStore.user.token,
                                setData: setDataSave,
                                setComplete: setComplete,
                                sequenceCheck: question.sequencecheck ?? 0,
                              ),
                            ),
                            question: question,
                            index: index + 1);
                      }
                      if (question.type == "numerical") {
                        return QuestionTile(
                            content: Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: NumberDoQuiz(
                                uniqueId: uniqueId,
                                slot: slot,
                                index: index,
                                html: question.html ?? "",
                                token: _userStore.user.token,
                                setData: setDataSave,
                                setComplete: setComplete,
                                sequenceCheck: question.sequencecheck ?? 0,
                              ),
                            ),
                            question: question,
                            index: index + 1);
                      }
                      if (question.type == "shortanswer") {
                        return QuestionTile(
                            content: Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: ShortAnswerDoQuiz(
                                uniqueId: uniqueId,
                                slot: slot,
                                index: index,
                                html: question.html ?? "",
                                token: _userStore.user.token,
                                setData: setDataSave,
                                setComplete: setComplete,
                                sequenceCheck: question.sequencecheck ?? 0,
                              ),
                            ),
                            question: question,
                            index: index + 1);
                      }
                      return QuestionTile(
                          content: Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Text(
                              "Unsupport quiz type ${question.type}",
                              style: const TextStyle(color: Colors.red),
                              textScaleFactor: 1.5,
                              overflow: TextOverflow.clip,
                            ),
                          ),
                          question: question,
                          index: index + 1);
                    },
                    itemScrollController: itemScrollController,
                    itemPositionsListener: itemPositionsListener,
                  ),
                ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        child: Center(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ...quizData?.questions?.map((e) {
                            int index = quizData!.questions!.indexOf(e);
                            return ListTile(
                              leading: InkWell(
                                onTap: () {
                                  itemScrollController.scrollTo(
                                    index: index,
                                    duration: const Duration(milliseconds: 1),
                                  );
                                },
                                child: Stack(
                                  children: [
                                    MaterialButton(
                                      shape: const CircleBorder(
                                          side: BorderSide(
                                              color: Colors.black, width: 2)),
                                      onPressed: () {
                                        itemScrollController.scrollTo(
                                          index: index,
                                          duration:
                                              const Duration(milliseconds: 1),
                                        );
                                      },
                                      child: Text(
                                        (e.number ?? 1).toString(),
                                        textScaleFactor: 1.1,
                                      ),
                                    ),
                                    complete[index]
                                        ? const Positioned(
                                            bottom: 6,
                                            right: 15,
                                            child: CircleAvatar(
                                              backgroundColor: Color.fromARGB(
                                                  255, 42, 185, 49),
                                              radius: 10,
                                              child: Icon(
                                                Icons.check,
                                                size: 10,
                                                color: Color.fromARGB(
                                                    204, 197, 242, 199),
                                              ),
                                            ),
                                          )
                                        : const SizedBox(
                                            height: 10,
                                            width: 10,
                                          ),
                                  ],
                                ),
                              ),
                              title: Text(points[index].toString() + " points"),
                            );
                          }).toList() ??
                          []
                    ],
                  ),
                ),
        ),
      ),
      endDrawerEnableOpenDragGesture: true,
      body: Stack(
        children: [
          _buildMainContent(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 95,
              width: Size.infinite.width,
              color: Colors.white,
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
                height: 90,
                padding: const EdgeInsets.only(bottom: 20, left: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(
                      Icons.alarm_outlined,
                      size: 35,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    widget.endTime == 0 || finish == true
                        ? const Text(
                            "                ",
                            style: TextStyle(fontSize: 16),
                          )
                        : CountdownTimer(
                            textStyle: const TextStyle(fontSize: 16),
                            endTime: widget.endTime,
                            onEnd: () async {
                              await endQuiz();
                              Navigator.pop(context);
                            },
                          ),
                  ],
                )),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20, right: 20),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: MoodleColors.blue,
                child: IconButton(
                  onPressed: () async {
                    bool check = await showDialogFinish();
                    if (check == true) {
                      await endQuiz();
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
