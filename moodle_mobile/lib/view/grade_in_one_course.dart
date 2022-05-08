import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/constants/dimens.dart';

class GradeInOneCourse extends StatefulWidget {
  const GradeInOneCourse({Key? key}) : super(key: key);

  @override
  State<GradeInOneCourse> createState() => _GradeInOneCourseState();
}

class _GradeInOneCourseState extends State<GradeInOneCourse> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
          // appBar: AppBar(
          //     automaticallyImplyLeading: true,
          //     title: const Text("Grade",
          //         textAlign: TextAlign.left,
          //         style: TextStyle(
          //             fontWeight: FontWeight.bold,
          //             fontSize: 18,
          //             letterSpacing: 1,
          //             color: MoodleColors.white))),
          children: [
            Padding(
              padding: const EdgeInsets.all(Dimens.default_padding * 3),
              child: Text("Do An Tot Nghiep",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: 1,
                      color: MoodleColors.black)),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(bottom: Dimens.default_padding * 3),
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.all(
                        Radius.circular(Dimens.default_border_radius * 3))),
                child: Text("8.0",
                    style: TextStyle(
                        fontSize: 18,
                        letterSpacing: 1,
                        color: MoodleColors.white)),
                padding: EdgeInsets.only(
                    top: Dimens.default_padding,
                    bottom: Dimens.default_padding,
                    left: Dimens.default_padding * 3,
                    right: Dimens.default_padding * 3),
              ),
            ),
            Divider(
              height: 10,
              thickness: 2,
            ),
            ListView(
              shrinkWrap: true, //height is fit to children
              physics: NeverScrollableScrollPhysics(),
              children: [
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.description),
                  title: Text("LINK NOP BAI TAP 1"),
                  trailing: Text("7.0"),
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.description),
                  title: Text("LINK NOP BAI TAP 1"),
                  trailing: Text("6.4"),
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.description),
                  title: Text("LINK NOP BAI TAP 1"),
                  trailing: Text("7.0"),
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.description),
                  title: Text("LINK NOP BAI TAP 1"),
                  trailing: Text("6.4"),
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.description),
                  title: Text("LINK NOP BAI TAP 1"),
                  trailing: Text("7.0"),
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.description),
                  title: Text("LINK NOP BAI TAP 1"),
                  trailing: Text("6.4"),
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.description),
                  title: Text("LINK NOP BAI TAP 1"),
                  trailing: Text("7.0"),
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.description),
                  title: Text("LINK NOP BAI TAP 1"),
                  trailing: Text("6.4"),
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.description),
                  title: Text("LINK NOP BAI TAP 1"),
                  trailing: Text("7.0"),
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.description),
                  title: Text("LINK NOP BAI TAP 1"),
                  trailing: Text("6.4"),
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.description),
                  title: Text("LINK NOP BAI TAP 1"),
                  trailing: Text("7.0"),
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.description),
                  title: Text("LINK NOP BAI TAP 1"),
                  trailing: Text("6.4"),
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.description),
                  title: Text("LINK NOP BAI TAP 1"),
                  trailing: Text("7.0"),
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.description),
                  title: Text("LINK NOP BAI TAP 1"),
                  trailing: Text("6.4"),
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.description),
                  title: Text("LINK NOP BAI TAP 1"),
                  trailing: Text("7.0"),
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.description),
                  title: Text("LINK NOP BAI TAP 1"),
                  trailing: Text("6.4"),
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.description),
                  title: Text("LINK NOP BAI TAP 1"),
                  trailing: Text("7.0"),
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.description),
                  title: Text("LINK NOP BAI TAP 1"),
                  trailing: Text("6.4"),
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.description),
                  title: Text("LINK NOP BAI TAP 1"),
                  trailing: Text("7.0"),
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.description),
                  title: Text("LINK NOP BAI TAP 1"),
                  trailing: Text("6.4"),
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.description),
                  title: Text("LINK NOP BAI TAP 1"),
                  trailing: Text("7.0"),
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.description),
                  title: Text("LINK NOP BAI TAP 1"),
                  trailing: Text("6.4"),
                ),
              ],
            ),
          ]),
    );
  }
}
