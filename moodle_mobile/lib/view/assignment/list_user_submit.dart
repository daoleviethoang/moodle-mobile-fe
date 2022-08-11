import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/models/assignment/user_submited.dart';
import 'package:moodle_mobile/view/assignment/files_assignment_for_teacher.dart';
import 'package:moodle_mobile/view/common/user/user_avatar_common.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:badges/badges.dart';

class ListUserSubmited extends StatelessWidget {
  final List<UserSubmited> userSubmiteds;
  final String title;
  final bool haveCheckBox;
  final int assignmentId;
  final UserStore userStore;
  final int duedate;
  const ListUserSubmited({
    Key? key,
    required this.userSubmiteds,
    required this.title,
    required this.haveCheckBox,
    required this.assignmentId,
    required this.userStore,
    required this.duedate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            snap: true,
            title: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
              overflow: TextOverflow.clip,
            ),
            leading: TextButton(
              style: TextButton.styleFrom(
                primary: Colors.white,
              ),
              child: const Icon(CupertinoIcons.back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
        body: SingleChildScrollView(
          child: Column(
              children: userSubmiteds
                  .map(
                    (e) => ListTile(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (_) {
                          return FilesAssignmentTeacherScreen(
                            assignId: assignmentId,
                            userId: e.id ?? 0,
                            duedate: duedate,
                            usersubmitted: e,
                          );
                        }));
                      },
                      leading: UserAvatarCommon(
                          // imageURL: avatar + "&token=" + userStore.user.token,
                          imageURL:
                              "https://www.w3schools.com/w3css/lights.jpg"),
                      title: Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          e.fullname ?? "",
                        ),
                      ),
                      subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            e.requiregrading == false && e.submitted == true
                                ? Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      color: Colors.green[900],
                                    ),
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10, bottom: 5, top: 5),
                                    child: const Text(
                                      'Đã chấm điểm',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                : Container(),
                            e.submitted == false
                                ? Container(
                                    margin: const EdgeInsets.only(top: 2),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      color: Colors.red[900],
                                    ),
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10, bottom: 5, top: 5),
                                    child: const Text(
                                      'Không có bài nộp',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                : Container(),
                            e.submitted == true
                                ? Container(
                                    margin: const EdgeInsets.only(top: 2),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      color: Colors.green[900],
                                    ),
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10, bottom: 5, top: 5),
                                    child: const Text(
                                      'Đã nộp đẻ chấm điểm',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                : Container()
                          ]),
                      trailing: Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: const Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                  )
                  .toList()),
        ),
      ),
    );
  }
}
