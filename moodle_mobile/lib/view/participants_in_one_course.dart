import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/constants/dimens.dart';
import 'package:moodle_mobile/constants/styles.dart';
import 'package:moodle_mobile/data/repository.dart';
import 'package:moodle_mobile/models/course/course_participants.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/common/image_view.dart';
import 'package:moodle_mobile/view/common/menu_item.dart';
import 'package:moodle_mobile/view/common/participant.dart';
import 'package:moodle_mobile/view/common/slidable_tile.dart';
import 'package:moodle_mobile/view/user_detail/user_detail.dart';
import 'package:moodle_mobile/view/user_detail/user_detail_student.dart';

class ParticipantsInOneCourse extends StatefulWidget {
  final int courseId;
  const ParticipantsInOneCourse({Key? key, required this.courseId})
      : super(key: key);
  @override
  State<ParticipantsInOneCourse> createState() =>
      _ParticipantsInOneCourseState();
}

class _ParticipantsInOneCourseState extends State<ParticipantsInOneCourse> {
  late Repository _repository;
  late UserStore _userStore;

  @override
  void initState() {
    super.initState();

    _repository = GetIt.instance<Repository>();
    _userStore = GetIt.instance<UserStore>();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getParticipantsInCourse(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasData) {
          List<CourseParticipantsModel> participants = snapshot.data;
          return SingleChildScrollView(
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
                            index: index)
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
                            index: index)
                        : Container();
                  },
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }

  Future getParticipantsInCourse() async {
    return await _repository.courseParticipant(
        _userStore.user.token, widget.courseId);
  }
}
