import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/models/course/course_content.dart';
import 'package:moodle_mobile/view/activity/album_tile.dart';

class ActivityScreen extends StatefulWidget {
  final int sectionIndex;
  final CourseContent content;
  final bool isTeacher;
  final Function(bool) reGetContent;
  const ActivityScreen(
      {Key? key,
      required this.sectionIndex,
      required this.isTeacher,
      required this.content,
      required this.reGetContent})
      : super(key: key);

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  List<CourseContent?> albums = [
    null,
    null,
  ];
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
          padding: EdgeInsets.only(top: 20, bottom: 20),
          child: Text(
            "Classroom Acitivities",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: MoodleColors.black80,
            ),
            textScaleFactor: 1.5,
          )),
      Column(
        children: albums
            .map((e) => const AlbumTile(
                  images: [
                    "https://miro.medium.com/max/1400/1*PblQquEXxZ6U1BmBNlEprA.jpeg",
                    "https://miro.medium.com/max/1400/1*PblQquEXxZ6U1BmBNlEprA.jpeg",
                    "https://miro.medium.com/max/1400/1*PblQquEXxZ6U1BmBNlEprA.jpeg",
                    "https://miro.medium.com/max/1400/1*PblQquEXxZ6U1BmBNlEprA.jpeg",
                    "https://miro.medium.com/max/1400/1*PblQquEXxZ6U1BmBNlEprA.jpeg",
                    "https://miro.medium.com/max/1400/1*PblQquEXxZ6U1BmBNlEprA.jpeg",
                    "https://miro.medium.com/max/1400/1*PblQquEXxZ6U1BmBNlEprA.jpeg",
                    "https://miro.medium.com/max/1400/1*PblQquEXxZ6U1BmBNlEprA.jpeg",
                    "https://miro.medium.com/max/1400/1*PblQquEXxZ6U1BmBNlEprA.jpeg",
                    "https://miro.medium.com/max/1400/1*PblQquEXxZ6U1BmBNlEprA.jpeg",
                    "https://miro.medium.com/max/1400/1*PblQquEXxZ6U1BmBNlEprA.jpeg",
                    "https://miro.medium.com/max/1400/1*PblQquEXxZ6U1BmBNlEprA.jpeg",
                  ],
                ))
            .toList(),
      )
    ]);
  }
}
