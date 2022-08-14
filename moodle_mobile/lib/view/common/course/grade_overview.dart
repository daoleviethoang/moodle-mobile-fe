import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/constants/dimens.dart';

class GradeOverview extends StatelessWidget {
  final int courseId;
  final String? courseName;
  final String? courseGrade;
  const GradeOverview(
      {Key? key, required this.courseId, this.courseName, this.courseGrade})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
              top: Dimens.default_padding * 2,
              bottom: Dimens.default_padding * 2),
          child: courseName == null
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Text(courseName!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: MoodleColors.black)),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: Dimens.default_padding * 2),
          child: Container(
            decoration: const BoxDecoration(
                color: MoodleColors.yellow_grade,
                borderRadius: BorderRadius.all(
                    Radius.circular(Dimens.default_border_radius * 3))),
            child: Text(courseGrade ?? "-",
                style: const TextStyle(
                    fontSize: 18, letterSpacing: 1, color: MoodleColors.white)),
            padding: const EdgeInsets.only(
                top: Dimens.default_padding - 2,
                bottom: Dimens.default_padding - 2,
                left: Dimens.default_padding * 4,
                right: Dimens.default_padding * 4),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(
              left: Dimens.default_padding, right: Dimens.default_padding),
          child: Divider(
            height: 10,
            thickness: 1.5,
          ),
        )
      ],
    );
  }
}