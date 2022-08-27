import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/constants/styles.dart';
import 'package:moodle_mobile/data/network/apis/custom_api/custom_api.dart';
import 'package:moodle_mobile/data/network/apis/quiz/quiz_api.dart';
import 'package:moodle_mobile/models/quiz/quizData.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/quiz/preview/type/essay_quiz.dart';
import 'package:moodle_mobile/view/quiz/preview/type/multi_choice_quiz.dart';
import 'package:moodle_mobile/view/quiz/preview/type/number_quiz.dart';
import 'package:moodle_mobile/view/quiz/preview/type/one_choice_quiz.dart';
import 'package:moodle_mobile/view/quiz/preview/type/short_answer_quiz.dart';
import 'package:moodle_mobile/view/quiz/question_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moodle_mobile/view/quiz/teacher_quiz/grade_quiz.dart';

class QuizReviewScreen extends StatefulWidget {
  final int attemptId;
  final String studentName;
  const QuizReviewScreen({
    Key? key,
    required this.attemptId,
    required this.studentName,
  }) : super(key: key);

  @override
  _QuizReviewScreenState createState() => _QuizReviewScreenState();
}

class _QuizReviewScreenState extends State<QuizReviewScreen> {
  bool isLoading = false;
  bool isUpdateMark = false;
  late UserStore _userStore;
  int page = 0;
  QuizData? quizData;
  bool error = false;
  CategoryType categoryType = CategoryType.quiz;
  QuizData? quizDataChanged;

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
      print(e.toString());
      setState(() {
        error = true;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  updateMarkOfAttempt() async {
    for (var e in quizData!.questions!) {
      if (e.type == "essay") {
        await CustomApi().setGradeQuizQuestion(
            _userStore.user.token,
            quizData!.attempt!.id!,
            e.slot!,
            e.mark == "" ? 0 : double.parse(e.mark!),
            "");
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context)!.update_success_message),
        backgroundColor: Colors.green));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.studentName,
            textAlign: TextAlign.left, style: MoodleStyles.appBarTitleStyle),
        centerTitle: false,
        actions: <Widget>[
          isUpdateMark
              ? IconButton(
                  iconSize: 35,
                  icon: Container(
                    width: 24,
                    height: 24,
                    padding: const EdgeInsets.all(2.0),
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  ),
                  onPressed: () {},
                )
              : IconButton(
                  iconSize: 35,
                  icon: const Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    await updateMarkOfAttempt();
                  },
                )
        ],
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            getCategoryUI(),
            Expanded(
              child: getScreenTabUI(categoryType),
            ),
          ],
        ),
      ),
    );
  }

  Widget getReviewQuiz() {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : error
            ? const Center(
                child: Text("Error loading"),
              )
            : SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.only(left: 15, right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: quizData?.questions?.map((question) {
                          int index = quizData!.questions!.indexOf(question);
                          int uniqueId = quizData?.attempt?.uniqueid ?? 0;
                          int slot = question.slot ?? 0;
                          if (question.type == "multichoice") {
                            if (question.html
                                    ?.contains("q$uniqueId:$slot" "_choice0") ??
                                false) {
                              return QuestionTile(
                                  content: MultiChoiceQuiz(
                                    uniqueId: uniqueId,
                                    slot: slot,
                                    token: _userStore.user.token,
                                    html: question.html ?? "",
                                  ),
                                  question: question,
                                  index: index + 1);
                            } else {
                              return QuestionTile(
                                  content: OneChoiceQuiz(
                                    uniqueId: uniqueId,
                                    slot: slot,
                                    token: _userStore.user.token,
                                    html: question.html ?? "",
                                  ),
                                  question: question,
                                  index: index + 1);
                            }
                          }
                          if (question.type == "essay") {
                            return QuestionTile(
                                content: EssayQuiz(
                                  uniqueId: uniqueId,
                                  slot: slot,
                                  token: _userStore.user.token,
                                  html: question.html ?? "",
                                ),
                                question: question,
                                index: index + 1);
                          }
                          if (question.type == "numerical") {
                            return QuestionTile(
                                content: NumberQuiz(
                                  uniqueId: uniqueId,
                                  slot: slot,
                                  token: _userStore.user.token,
                                  html: question.html ?? "",
                                ),
                                question: question,
                                index: index + 1);
                          }
                          if (question.type == "shortanswer") {
                            return QuestionTile(
                                content: ShortAnswerQuiz(
                                  uniqueId: uniqueId,
                                  slot: slot,
                                  token: _userStore.user.token,
                                  html: question.html ?? "",
                                ),
                                question: question,
                                index: index + 1);
                          }
                          return QuestionTile(
                              content: Text(
                                "Unsupport quiz type ${question.type}",
                                style: const TextStyle(color: Colors.red),
                                textScaleFactor: 1.5,
                                overflow: TextOverflow.clip,
                              ),
                              question: question,
                              index: index + 1);
                        }).toList() ??
                        [],
                  ),
                ),
              );
  }

  Widget getCategoryUI() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 6.0, right: 6.0, top: 10.0, bottom: 15),
      child: Center(
        child: Row(
          children: <Widget>[
            getButtonUI(CategoryType.quiz, categoryType == CategoryType.quiz),
            getButtonUI(CategoryType.grade, categoryType == CategoryType.grade)
          ],
        ),
      ),
    );
  }

  Widget getButtonUI(CategoryType categoryTypeData, bool isSelected) {
    String txt = '';
    if (CategoryType.quiz == categoryTypeData) {
      txt = AppLocalizations.of(context)!.quizz;
    } else if (CategoryType.grade == categoryTypeData) {
      txt = AppLocalizations.of(context)!.grade;
    }
    return Expanded(
      child: Container(
        height: 48,
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isSelected ? MoodleColors.blueButton : MoodleColors.white,
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          boxShadow: [
            BoxShadow(
              color: MoodleColors.black.withOpacity(0.25),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.white24,
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            onTap: () {
              setState(() {
                categoryType = categoryTypeData;
              });
            },
            child: Center(
              child: Text(
                txt,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  letterSpacing: 0.27,
                  color: isSelected ? MoodleColors.blue : MoodleColors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getScreenTabUI(CategoryType categoryTypeData) {
    if (CategoryType.quiz == categoryTypeData) {
      return getReviewQuiz();
    } else if (CategoryType.grade == categoryTypeData) {
      return GradeQuiz(
        quizData: quizData,
      );
    }
    return getReviewQuiz();
  }
}

enum CategoryType { quiz, grade }
