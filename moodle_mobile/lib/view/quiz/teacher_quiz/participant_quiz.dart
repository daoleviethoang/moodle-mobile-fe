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
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/constants/styles.dart';
import 'package:moodle_mobile/data/network/apis/quiz/quiz_api.dart';
import 'package:moodle_mobile/data/network/apis/user/user_api.dart';
import 'package:moodle_mobile/data/network/dio_client.dart';
import 'package:moodle_mobile/di/service_locator.dart';
import 'package:moodle_mobile/models/quiz/attempt.dart';
import 'package:moodle_mobile/models/quiz/user_quiz.dart';
import 'package:moodle_mobile/models/user/user_overview.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/common/user/user_avatar_common.dart';

class ParticipantQuiz extends StatefulWidget {
  final int quizInstanceId;
  final String quizName;
  final List<Attempt> attemps;
  const ParticipantQuiz({
    Key? key,
    required this.quizInstanceId,
    required this.quizName,
    required this.attemps,
  }) : super(key: key);

  @override
  State<ParticipantQuiz> createState() => _ParticipantQuizState();
}

class _ParticipantQuizState extends State<ParticipantQuiz> {
  List<UserQuizz> usersSubmitedQuizz = [];
  late UserStore _userStore;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _userStore = GetIt.instance<UserStore>();
    loadUserSubmitedQuizz();
  }

  loadUserSubmitedQuizz() async {
    setState(() {
      isLoading = true;
    });
    try {
      List<UserQuizz> getUserQuizz = [];
      List<int?> ids = [];
      print("======" + getUserQuizz.toString());

      for (int i = 0; i < widget.attemps.length; i++) {
        ids.add(widget.attemps[i].userid);
        UserQuizz userQuizz = UserQuizz(
            attempId: widget.attemps[i].id,
            grade: widget.attemps[i].sumgrades ?? 0);
        getUserQuizz.add(userQuizz);
      }
      print("======" + getUserQuizz.toString());
      List<UserOverview> getUsers = await UserApi(getIt<DioClient>())
          .getUserByIds(_userStore.user.token, ids);
      for (int i = 0; i < getUsers.length; i++) {
        getUserQuizz[i].id = getUsers[i].id;
        getUserQuizz[i].fullname = getUsers[i].fullname;
        getUserQuizz[i].profileimageurl = getUsers[i].profileimageurl;
      }
      print("======" + getUserQuizz.toString());
      setState(() {
        usersSubmitedQuizz = getUserQuizz;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quizName,
            textAlign: TextAlign.left, style: MoodleStyles.appBarTitleStyle),
        centerTitle: false,
        automaticallyImplyLeading: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: List<Widget>.generate(
              usersSubmitedQuizz.length,
              (int index) => Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: ListTile(
                    leading: UserAvatarCommon(
                        imageURL: usersSubmitedQuizz[index].profileimageurl!),
                    title: Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 4),
                      child: Text(
                        usersSubmitedQuizz[index].fullname!,
                      ),
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
                              usersSubmitedQuizz[index].grade.toString(),
                              style: const TextStyle(color: Color(0xffFF8A00)),
                            ),
                          ),
                        )),
                  ),
                ),
              ),
            )),
    );
  }
}
