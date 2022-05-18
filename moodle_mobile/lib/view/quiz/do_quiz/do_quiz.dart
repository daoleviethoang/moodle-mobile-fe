import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/data/network/apis/quiz/quiz_api.dart';
import 'package:moodle_mobile/models/quiz/quizData.dart';
import 'package:moodle_mobile/models/quiz/quiz_save.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/quiz/do_quiz/type/multi_choice_quiz.dart';
import 'package:moodle_mobile/view/quiz/do_quiz/type/one_choice_quiz.dart';
import 'package:moodle_mobile/view/quiz/preview/type/multi_choice_quiz.dart';
import 'package:moodle_mobile/view/quiz/preview/type/one_choice_quiz.dart';
import 'package:moodle_mobile/view/quiz/question_tile.dart';

class QuizDoScreen extends StatefulWidget {
  final int attemptId;
  final String title;
  const QuizDoScreen({
    Key? key,
    required this.attemptId,
    required this.title,
  }) : super(key: key);

  @override
  _QuizDoScreenState createState() => _QuizDoScreenState();
}

class _QuizDoScreenState extends State<QuizDoScreen> {
  bool isLoading = false;
  late UserStore _userStore;
  int page = 0;
  List<QuizSaveData> list = [];
  List<QuizSaveData> temp = [];
  QuizData? quizData;
  bool error = false;

  saveQuiz() async {
    for (var element in temp) {
      try {
        await QuizApi().saveQuizData(_userStore.user.token, widget.attemptId,
            element.answers, element.values);
      } catch (e) {
        print("Can't save quiz" + element.answers.toString());
      }
    }
  }

  setDataSave(int index, List<String> answers, List<String> values) {
    setState(() {
      list[index] = QuizSaveData(answers: answers, values: values);
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
          .getDoQuizData(_userStore.user.token, widget.attemptId, page);
      setState(() {
        quizData = temp;
      });
    } catch (e) {
      print(e.toString());
      setState(() {
        error = true;
      });
    }
    setState(() {
      list = [];
      isLoading = false;
    });
  }

  setPage(int index) {
    setState(() {
      temp.addAll(list);
      page = index;
    });
    load();
    saveQuiz();
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
            : error
                ? const Center(
                    child: Text("Error loading"),
                  )
                : SingleChildScrollView(
                    child: Container(
                      margin:
                          const EdgeInsets.only(left: 10, right: 10, top: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: quizData?.questions?.map((question) {
                              int index =
                                  quizData!.questions!.indexOf(question);
                              int uniqueId = quizData?.attempt?.uniqueid ?? 0;
                              int slot = question.slot ?? 0;
                              setState(() {
                                list.add(QuizSaveData(answers: [], values: []));
                              });
                              if (question.type == "multichoice") {
                                if (question.html?.contains(
                                        "q$uniqueId:$slot" "_choice0") ??
                                    false) {
                                  return QuestionTile(
                                      content: MultiChoiceDoQuiz(
                                        uniqueId: uniqueId,
                                        slot: slot,
                                        html: question.html ?? "",
                                        index: index,
                                        setData: setDataSave,
                                        sequenceCheck:
                                            question.sequencecheck ?? 0,
                                      ),
                                      question: question,
                                      index: index);
                                } else {
                                  return QuestionTile(
                                      content: OneChoiceDoQuiz(
                                        uniqueId: uniqueId,
                                        slot: slot,
                                        html: question.html ?? "",
                                        index: index,
                                        setData: setDataSave,
                                        sequenceCheck:
                                            question.sequencecheck ?? 0,
                                      ),
                                      question: question,
                                      index: index);
                                }
                              }
                              return Container();
                            }).toList() ??
                            [],
                      ),
                    ),
                  ),
      ),
    );
  }
}