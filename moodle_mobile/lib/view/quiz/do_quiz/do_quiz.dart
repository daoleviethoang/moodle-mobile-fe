import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/data/network/apis/quiz/quiz_api.dart';
import 'package:moodle_mobile/models/quiz/question.dart';
import 'package:moodle_mobile/models/quiz/quizData.dart';
import 'package:moodle_mobile/models/quiz/quiz_save.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/quiz/do_quiz/type/multi_choice_quiz.dart';
import 'package:moodle_mobile/view/quiz/do_quiz/type/one_choice_quiz.dart';
import 'package:moodle_mobile/view/quiz/question_tile.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

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

  saveQuiz() async {
    for (var element in list) {
      if (element.answers.isNotEmpty) {
        try {
          await QuizApi().saveQuizData(_userStore.user.token, widget.attemptId,
              element.answers, element.values);
        } catch (e) {
          print("Can't save quiz" + element.answers.toString());
        }
      }
    }
  }

  endQuiz() async {
    try {
      await QuizApi().endQuiz(
        _userStore.user.token,
        widget.attemptId,
      );
    } catch (e) {
      print("Can't end quiz");
    }
  }

  setDataSave(int index, List<String> answers, List<String> values) async {
    setState(() {
      list[index] = QuizSaveData(answers: answers, values: values);
    });
    await saveQuiz();
  }

  setComplete(int index, bool value) async {
    setState(() {
      complete[index] = value;
    });
  }

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
    } catch (e) {
      setState(() {
        error = true;
      });
    }
    setState(() {
      isLoading = false;
    });
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
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
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
                                setData: setDataSave,
                                setComplete: setComplete,
                                sequenceCheck: question.sequencecheck ?? 0,
                              ),
                              question: question,
                              index: question.number ?? 1);
                        }
                      }
                      return Container();
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
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ...quizData?.questions?.map((e) {
                          int index = quizData!.questions!.indexOf(e);
                          return ListTile(
                            leading: MaterialButton(
                              shape: CircleBorder(
                                  side: BorderSide(
                                      color: Colors.black, width: 2)),
                              onPressed: () {
                                itemScrollController.scrollTo(
                                  index: index,
                                  duration: Duration(milliseconds: 1),
                                );
                              },
                              child: Text(
                                (e.number ?? 1).toString(),
                                textScaleFactor: 1.1,
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
      endDrawerEnableOpenDragGesture: true,
      body: Stack(
        children: [
          _buildMainContent(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: CountdownTimer(
                endTime: widget.endTime,
                onEnd: () async {
                  await endQuiz();
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
