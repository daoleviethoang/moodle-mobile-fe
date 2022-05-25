import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/colors.dart';

class CourseCommonView extends StatelessWidget {
  final String role;
  final String course;

  const CourseCommonView({Key? key, required this.role, required this.course})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(
            left: 20.0, top: 8.0, right: 0.0, bottom: 8.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Row(
            children: <Widget>[
              const Icon(
                Icons.info_outline,
                color: MoodleColors.iconGrey,
                size: 24,
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        role + ' in the course ',
                        style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 13,
                            letterSpacing: 0.27,
                            color: MoodleColors.black),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        course,
                        softWrap: true,
                        style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 13,
                            letterSpacing: 0.27,
                            color: MoodleColors.text_blue),
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
