import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/constants/styles.dart';
import 'package:moodle_mobile/data/repository.dart';
import 'package:moodle_mobile/models/course/course_participants.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/common/participant.dart';

class ParticipantsInOneCourse extends StatefulWidget {
  final int courseId;
  final String? courseName;
  const ParticipantsInOneCourse(
      {Key? key, required this.courseId, required this.courseName})
      : super(key: key);
  @override
  State<ParticipantsInOneCourse> createState() =>
      _ParticipantsInOneCourseState();
}

class _ParticipantsInOneCourseState extends State<ParticipantsInOneCourse> {
  late Repository _repository;
  late UserStore _userStore;
  bool isLoad = true;
  List<CourseParticipantsModel> participants = [];

  @override
  void initState() {
    super.initState();

    _repository = GetIt.instance<Repository>();
    _userStore = GetIt.instance<UserStore>();
    getParticipantsInCourse();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.courseId);
    return isLoad
        ? CircularProgressIndicator()
        : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 16),
                const Text('People in this course',
                    style: MoodleStyles.courseHeaderStyle),
                Container(height: 16),
                const Text(
                  'Teacher',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.5),
                ),
                ...List.generate(
                  participants.length,
                  (index) {
                    return participants[index].roles[0].roleID != 5
                        ? ParticipantListTile(
                            fullname: participants[index].fullname,
                            id: participants[index].id,
                            role: participants[index].roles[0].roleID,
                            userStore: _userStore,
                            courseName: widget.courseName,
                            avatar: participants[index].avatar.replaceAll(
                                    "pluginfile.php",
                                    "webservice/pluginfile.php") +
                                (participants[index].avatar.contains("?")
                                    ? "&token=" + _userStore.user.token
                                    : "?token=" + _userStore.user.token),
                          )
                        : Container();
                  },
                ),
                Container(height: 16),
                const Text(
                  'Student',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.5),
                ),
                ...List.generate(
                  participants.length,
                  (index) {
                    return participants[index].roles[0].roleID == 5
                        ? ParticipantListTile(
                            fullname: participants[index].fullname,
                            id: participants[index].id,
                            role: participants[index].roles[0].roleID,
                            userStore: _userStore,
                            courseName: widget.courseName,
                            avatar: participants[index].avatar.replaceAll(
                                    "pluginfile.php",
                                    "webservice/pluginfile.php") +
                                (participants[index].avatar.contains("?")
                                    ? "&token=" + _userStore.user.token
                                    : "?token=" + _userStore.user.token),
                          )
                        : Container();
                  },
                ),
              ],
            ),
          );
  }

  getParticipantsInCourse() async {
    try {
      List<CourseParticipantsModel> courseParticipants = await _repository
          .courseParticipant(_userStore.user.token, widget.courseId);
      setState(() {
        participants = courseParticipants;
        isLoad = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
    }
  }
}
