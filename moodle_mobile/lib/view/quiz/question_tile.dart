import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/models/quiz/question.dart';

class QuestionTile extends StatefulWidget {
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
  State<QuestionTile> createState() => _QuestionTileState();
}

class _QuestionTileState extends State<QuestionTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            "Question " + widget.index.toString() + ":",
            textScaleFactor: 1.2,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: MaterialButton(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            color: MoodleColors.grade_quiz_foreground,
            onPressed: () {},
            child: Text(
              (widget.question.maxmark ?? 1).toString() + " points",
              textScaleFactor: 1.1,
              style: TextStyle(color: MoodleColors.grade_quiz_text),
            ),
          ),
        ),
        widget.content,
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
