import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/models/quiz/question.dart';
import 'package:moodle_mobile/models/quiz/quizData.dart';
import 'package:moodle_mobile/view/common/content_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GradeQuiz extends StatefulWidget {
  final QuizData? quizData;

  const GradeQuiz({Key? key, required this.quizData}) : super(key: key);

  @override
  State<GradeQuiz> createState() => _GradeQuizState();
}

class _GradeQuizState extends State<GradeQuiz> {
  QuizData? quizLocal;
  int sumMaxMark = 0;
  double sumMark = 0;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  loadData() {
    setState(() {
      isLoading = true;
    });
    for (var i in widget.quizData!.questions!) {
      sumMaxMark += i.maxmark!;
      sumMark += i.mark!.isEmpty
          ? 0
          : i.mark == "0.00"
              ? 0
              : double.parse(i.mark!);
    }
    setState(() {
      quizLocal = widget.quizData;
      sumMaxMark = sumMaxMark;
      sumMark = sumMark;
    });

    setState(() {
      isLoading = false;
    });
  }

  bool checkTypeQuiz(Question question) {
    if (question.type == "essay") {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.summary,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                Text(
                  (sumMark == 0 ? 0.toString() : sumMark.toString()) +
                      "/" +
                      sumMaxMark.toString() +
                      " | " +
                      quizLocal!.questions!.length.toString() +
                      " " +
                      AppLocalizations.of(context)!.question,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                      fontSize: 18),
                ),
              ],
            ),
          ),
          const LineItem(width: 1.0),
          SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 300,
              child: ListView(
                children: List<Widget>.generate(
                  quizLocal!.questions!.length,
                  (int index) => ListTile(
                    leading: Container(
                      width: 100,
                      //padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Text(
                        AppLocalizations.of(context)!.question +
                            " " +
                            (index + 1).toString() +
                            ":",
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: checkTypeQuiz(quizLocal!.questions![index])
                              ? TextField(
                                  onChanged: (value) {
                                    widget.quizData!.questions![index].mark =
                                        value;
                                  },
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true, signed: false),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r"[0-9.]")),
                                    TextInputFormatter.withFunction(
                                        (oldValue, newValue) {
                                      try {
                                        final text = newValue.text;
                                        if (text.isNotEmpty) {
                                          double value = double.parse(text);
                                          if (value >
                                              quizLocal!
                                                  .questions![index].maxmark!
                                                  .toDouble()) {
                                            return oldValue;
                                          }
                                        }
                                        return newValue;
                                      } catch (e) {}
                                      return oldValue;
                                    }),
                                  ],
                                  controller: TextEditingController(
                                    text: quizLocal!.questions![index].mark
                                        .toString(),
                                  ),
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 8.0),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                      width: 1,
                                    )),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                )
                              : TextField(
                                  enabled: false,
                                  controller: TextEditingController(
                                    text: quizLocal!.questions![index].mark
                                        .toString(),
                                  ),
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 8.0),
                                    disabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                      color: MoodleColors.gray,
                                      width: 1,
                                    )),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                        checkTypeQuiz(quizLocal!.questions![index])
                            ? const Padding(
                                padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                                child: SizedBox(
                                  height: 25,
                                  width: 25,
                                ))
                            : quizLocal!.questions![index].status == "Incorrect"
                                ? const Padding(
                                    padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.red,
                                    ),
                                  )
                                : const Padding(
                                    padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                                    child: Icon(
                                      Icons.check,
                                      color: Color(0xff2AB930),
                                    ),
                                  ),
                      ],
                    ),
                    trailing: SizedBox(
                        width: 100,
                        height: 30,
                        child: DecoratedBox(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Color(0xffF8DAAD),
                          ),
                          child: Center(
                            child: Text(
                              quizLocal!.questions![index].maxmark.toString() +
                                  " " +
                                  AppLocalizations.of(context)!.points,
                              style: const TextStyle(color: Color(0xffFF8A00)),
                            ),
                          ),
                        )),
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
