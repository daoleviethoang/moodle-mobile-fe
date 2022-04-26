import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:flutter_html/flutter_html.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:moodle_mobile/data/network/apis/assignment/assignment_api.dart';
import 'package:moodle_mobile/models/assignment/assignment.dart';
import 'package:moodle_mobile/models/assignment/attemp_assignment.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/assignment/date_assignment_tile.dart';
import 'package:moodle_mobile/view/assignment/files_assignment.dart';
import 'package:moodle_mobile/view/assignment/submission_status_tile.dart';
import 'package:moodle_mobile/view/common/custom_button.dart';

class AssignmentScreen extends StatefulWidget {
  final int assignInstanceId;
  final int courseId;
  final String title;
  const AssignmentScreen({
    Key? key,
    required this.assignInstanceId,
    required this.courseId,
    required this.title,
  }) : super(key: key);

  @override
  _AssignmentScreenState createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  Assignment assignment = Assignment();
  AttemptAssignment attempt = AttemptAssignment();
  bool isLoading = false;
  String dateDiff = "";
  late UserStore _userStore;

  @override
  void initState() {
    _userStore = GetIt.instance<UserStore>();
    super.initState();
    isLoading = true;
    loadAssignment();
    setState(() {
      isLoading = false;
    });
  }

  Future<Assignment> ReadData(int assignInstanceId, int courseId) async {
    try {
      List<Assignment> assigns = await AssignmentApi()
          .getAssignments(_userStore.user.token, assignInstanceId, courseId);
      Assignment assign = Assignment();
      for (var item in assigns) {
        if (item.id == assignInstanceId) {
          assign = item;
        }
      }
      return assign;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
    }
    return Assignment();
  }

  Future<AttemptAssignment> ReadData2(int assignInstanceId) async {
    try {
      AttemptAssignment assign = await AssignmentApi()
          .getAssignment(_userStore.user.token, assignInstanceId);
      if (assign.submission == null) {
        assign = await AssignmentApi()
            .getAssignment(_userStore.user.token, assignInstanceId);
      }
      return assign;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
    }
    return AttemptAssignment();
  }

  void loadAssignment() async {
    isLoading = true;
    Assignment temp = await ReadData(widget.assignInstanceId, widget.courseId);
    AttemptAssignment temp2 = await ReadData2(widget.assignInstanceId);
    setState(() {
      assignment = temp;
      attempt = temp2;
      isLoading = false;
    });
    dateDiffSubmit();
  }

  void loadAssignmentAttempt() async {
    AttemptAssignment temp2 = await ReadData2(widget.assignInstanceId);
    setState(() {
      attempt = temp2;
    });
  }

  dateDiffSubmit() {
    DateTime modifi = DateTime.fromMillisecondsSinceEpoch(
        (attempt.submission?.timemodified ?? 0) * 1000);
    DateTime dueDate =
        DateTime.fromMillisecondsSinceEpoch((assignment.duedate ?? 0) * 1000);
    Duration duration = modifi.difference(dueDate);
    var zero = DateTime(0);
    final dateTime = zero.add(duration.abs());
    int day = dateTime.day - 1;
    if (day > 0) {
      setState(() {
        dateDiff = "Submitted " +
            day.toString() +
            " days " +
            dateTime.hour.toString() +
            " hours " +
            (duration.isNegative ? "late" : " early");
      });
      return;
    }
    setState(() {
      dateDiff = "Submitted " +
          dateTime.hour.toString() +
          " hours " +
          dateTime.minute.toString() +
          " minutes " +
          (duration.isNegative ? "late" : " early");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            snap: true,
            title: Text(
              widget.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
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
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DateAssignmentTile(
                        date: (assignment.allowsubmissionsfromdate ?? 0) * 1000,
                        title: "Opened",
                        iconColor: Colors.grey,
                        backgroundIconColor:
                            const Color.fromARGB(255, 217, 217, 217),
                      ),
                      DateAssignmentTile(
                        date: (assignment.duedate ?? 0) * 1000,
                        title: "Due",
                        iconColor: Colors.green,
                        backgroundIconColor: Colors.greenAccent,
                      ),
                      const Divider(),
                      Card(
                        child: Html(
                          data: assignment.intro ?? "",
                          shrinkWrap: true,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        "Submission status",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SubmissionStatusTile(
                        leftText: "Submission status",
                        rightText: "Submitted for grading",
                      ),
                      SubmissionStatusTile(
                        leftText: "Grading status",
                        rightText: attempt.gradingstatus ?? "Not graded",
                      ),
                      SubmissionStatusTile(
                          leftText: "Time remaining", rightText: dateDiff),
                      SubmissionStatusTile(
                          leftText: "Last modified",
                          rightText: DateFormat("hh:mmaa, dd MMMM, yyyy")
                              .format(DateTime.fromMillisecondsSinceEpoch(
                                  attempt.submission?.timemodified ?? 0))),
                      SubmissionStatusTile(
                        leftText: "File submissions",
                        rightText: (attempt.submission?.plugins?[0]
                                        .fileareas?[0].files ??
                                    [])
                                .length
                                .toString() +
                            " files",
                        rightTextColor: Colors.blue,
                      ),
                      const SubmissionStatusTile(
                        leftText: "Submission comments",
                        rightText: "0 comments...",
                        rightTextColor: Colors.blue,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      CustomButtonWidget(
                        textButton: "View file submission",
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) {
                                return FilesAssignmentScreen(
                                  assignId: widget.assignInstanceId,
                                  dueDate: assignment.duedate ?? 0,
                                  maxByteSize: int.parse(
                                      assignment.configs != null
                                          ? assignment.configs!
                                              .where((element) =>
                                                  element.name ==
                                                  "maxsubmissionsizebytes")
                                              .first
                                              .value
                                          : "5242880"),
                                  maxFileCount: int.parse(assignment.configs !=
                                          null
                                      ? assignment.configs!
                                          .where((element) =>
                                              element.name ==
                                              "maxfilesubmissions")
                                          .first
                                          .value
                                      : "1"),
                                  attempt: attempt,
                                  reload: loadAssignmentAttempt,
                                );
                              },
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
