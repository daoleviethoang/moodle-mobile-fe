import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/models/quiz/question.dart';

class QuestionTile extends StatelessWidget {
  final Widget content;
  final Question question;
  final int index;
  const QuestionTile(
      {Key? key,
      required this.content,
      required this.question,
      required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
          title: Text(
            "Question " + index.toString() + ":",
            textScaleFactor: 1.2,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: MaterialButton(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            color: MoodleColors.grade_quiz_foreground,
            onPressed: () {},
            child: Text(
              (question.maxmark ?? 1).toString() + " points",
              textScaleFactor: 1.1,
              style: const TextStyle(color: MoodleColors.grade_quiz_text),
            ),
          ),
        ),
        content,
        const SizedBox(
          height: 40,
        ),
      ],
    );
  }
}
