import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/data/network/apis/quiz/quiz_api.dart';
import 'package:moodle_mobile/models/quiz/quizData.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/quiz/type/multi_choice_quiz.dart';
import 'package:moodle_mobile/view/quiz/type/one_choice_quiz.dart';

class QuizPreviewScreen extends StatefulWidget {
  final int attemptId;
  final String title;
  const QuizPreviewScreen({
    Key? key,
    required this.attemptId,
    required this.title,
  }) : super(key: key);

  @override
  _QuizPreviewScreenState createState() => _QuizPreviewScreenState();
}

class _QuizPreviewScreenState extends State<QuizPreviewScreen> {
  bool isLoading = false;
  late UserStore _userStore;
  int page = 0;
  QuizData? quizData;
  bool error = false;

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
          .getPreviewQuiz(_userStore.user.token, widget.attemptId);
      setState(() {
        quizData = temp;
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
                              if (question.type == "multichoice") {
                                int uniqueId = quizData?.attempt?.uniqueid ?? 0;
                                int slot = question.slot ?? 0;
                                if (question.html?.contains(
                                        "q$uniqueId:$slot" "_choice0") ??
                                    false) {
                                  return MultiChoiceQuiz();
                                } else {
                                  return OneChoiceQuiz();
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
