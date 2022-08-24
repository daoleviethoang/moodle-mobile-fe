//  ListTile(
//           visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
//           title: Text(
//             "Question " + index.toString() + ":",
//             textScaleFactor: 1.2,
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//           trailing: MaterialButton(
//             shape: const RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(8))),
//             color: MoodleColors.grade_quiz_foreground,
//             onPressed: () {},
//             child: Text(
//               (question.maxmark ?? 1).toString() + " points",
//               textScaleFactor: 1.1,
//               style: const TextStyle(color: MoodleColors.grade_quiz_text),
//             ),
//           ),
//         ),

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_html/style.dart';
import 'package:moodle_mobile/constants/styles.dart';
import 'package:moodle_mobile/view/common/user/user_avatar_common.dart';

class ParticipantQuiz extends StatefulWidget {
  const ParticipantQuiz({Key? key}) : super(key: key);

  @override
  State<ParticipantQuiz> createState() => _ParticipantQuizState();
}

class _ParticipantQuizState extends State<ParticipantQuiz> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz 1",
            textAlign: TextAlign.left, style: MoodleStyles.appBarTitleStyle),
        centerTitle: false,
        automaticallyImplyLeading: true,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: ListTile(
                leading: UserAvatarCommon(imageURL: ""),
                title: Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 4),
                  child: Text(
                    "Truong Quoc An",
                  ),
                ),
                trailing: SizedBox(
                    width: 100,
                    height: 30,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Color(0xffF8DAAD),
                      ),
                      child: Center(
                        child: Text(
                          "10 points",
                          style: TextStyle(color: Color(0xffFF8A00)),
                        ),
                      ),
                    )),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: ListTile(
              leading: UserAvatarCommon(imageURL: ""),
              title: Padding(
                padding: EdgeInsets.only(top: 8, bottom: 4),
                child: Text(
                  "Truong Quoc An",
                ),
              ),
              trailing: SizedBox(
                  width: 100,
                  height: 30,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Color(0xffF8DAAD),
                    ),
                    child: Center(
                      child: Text(
                        "10 points",
                        style: TextStyle(color: Color(0xffFF8A00)),
                      ),
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
