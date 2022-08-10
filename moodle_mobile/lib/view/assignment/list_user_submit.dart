import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moodle_mobile/models/assignment/user_submited.dart';
import 'package:moodle_mobile/view/assignment/files_assignment_for_teacher.dart';

class ListUserSubmited extends StatelessWidget {
  final List<UserSubmited> userSubmiteds;
  final String title;
  final bool haveCheckBox;
  final int assignmentId;
  const ListUserSubmited({
    Key? key,
    required this.userSubmiteds,
    required this.title,
    required this.haveCheckBox,
    required this.assignmentId,
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
                      onTap: e.submitted == false
                          ? null
                          : () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (_) {
                                return FilesAssignmentTeacherScreen(
                                  assignId: assignmentId,
                                  userId: e.id ?? 0,
                                );
                              }));
                            },
                      title: Text(
                        e.fullname ?? "",
                      ),
                      trailing: haveCheckBox
                          ? Checkbox(
                              value: e.submitted,
                              shape: const CircleBorder(),
                              activeColor: Colors.green,
                              onChanged: (value) {},
                            )
                          : const Icon(Icons.arrow_forward_ios),
                    ),
                  )
                  .toList()),
        ),
      ),
    );
  }
}
