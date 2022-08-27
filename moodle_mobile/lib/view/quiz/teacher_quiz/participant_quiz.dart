import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/constants/styles.dart';
import 'package:moodle_mobile/data/network/apis/custom_api/custom_api.dart';
import 'package:moodle_mobile/data/network/apis/user/user_api.dart';
import 'package:moodle_mobile/data/network/dio_client.dart';
import 'package:moodle_mobile/di/service_locator.dart';
import 'package:moodle_mobile/models/quiz/attempt.dart';
import 'package:moodle_mobile/models/quiz/attempt_user.dart';
import 'package:moodle_mobile/models/quiz/user_quiz.dart';
import 'package:moodle_mobile/models/user/user_overview.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/common/user/user_avatar_common.dart';
import 'package:moodle_mobile/view/quiz/teacher_quiz/review_quiz.dart';

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
      List<AttemptUser> attemptUsers = await CustomApi()
          .getListAttemptInQuiz(_userStore.user.token, widget.quizInstanceId);
      List<int?> ids = [];
      for (int i = 0; i < attemptUsers.length; i++) {
        if (attemptUsers[i].userid == _userStore.user.id) continue;
        ids.add(attemptUsers[i].userid);
        UserQuizz userQuizz = UserQuizz();
        userQuizz.id = attemptUsers[i].userid;
        userQuizz.grade = attemptUsers[i].sumgrades ?? 0;
        userQuizz.attempId = attemptUsers[i].id;
        getUserQuizz.add(userQuizz);
      }
      List<UserOverview> getUsers = await UserApi(getIt<DioClient>())
          .getUserByIds(_userStore.user.token, ids);
      for (int i = 0; i < getUsers.length; i++) {
        for (int j = 0; j < getUserQuizz.length; j++) {
          if (getUsers[i].id == getUserQuizz[j].id) {
            getUserQuizz[j].fullname = getUsers[i].fullname;
            getUserQuizz[j].profileimageurl = getUsers[i].profileimageurl;
          }
        }
      }
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
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) {
                        return QuizReviewScreen(
                          studentName: usersSubmitedQuizz[index].fullname!,
                          attemptId: usersSubmitedQuizz[index].attempId!,
                        );
                      }));
                    },
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
