import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:moodle_mobile/models/assignment/assignment.dart';
import 'package:moodle_mobile/models/assignment/attemp_assignment.dart';
import 'package:moodle_mobile/view/assignment/date_assignment_tile.dart';
import 'package:moodle_mobile/view/assignment/files_assignment.dart';
import 'package:moodle_mobile/view/assignment/submission_status_tile.dart';
import 'package:moodle_mobile/view/common/custom_button.dart';

class AssignmentScreen extends StatefulWidget {
  final int assignId;
  final int courseId;
  const AssignmentScreen(
      {Key? key, required this.assignId, required this.courseId})
      : super(key: key);

  @override
  _AssignmentScreenState createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  Assignment assignment = Assignment();
  AttemptAssignment attempt = AttemptAssignment();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    loadAssignment();
    setState(() {
      isLoading = false;
    });
  }

  void loadAssignment() async {
    isLoading = true;
    Assignment temp = await ReadJsonData(widget.assignId, widget.courseId);
    AttemptAssignment temp2 =
        await ReadJsonData2(widget.assignId, widget.courseId);
    setState(() {
      assignment = temp;
      attempt = temp2;
      isLoading = false;
    });
  }

  void loadAssignmentAttempt() async {
    AttemptAssignment temp2 =
        await ReadJsonData2(widget.assignId, widget.courseId);
    setState(() {
      attempt = temp2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      child: Html(data: assignment.intro ?? ""),
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
                    const SubmissionStatusTile(
                      leftText: "Grading status",
                      rightText: "Not graded",
                    ),
                    const SubmissionStatusTile(
                        leftText: "Time remaining",
                        rightText: "Submitted 5 hours 8 mins early"),
                    SubmissionStatusTile(
                        leftText: "Last modified",
                        rightText: DateFormat("hh:mmaa, dd MMMM, yyyy").format(
                            DateTime.fromMillisecondsSinceEpoch(
                                attempt.submission?.timemodified ?? 0))),
                    SubmissionStatusTile(
                      leftText: "File submissions",
                      rightText: (attempt.submission?.plugins?[0].fileareas?[0]
                                      .files ??
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
                                maxByteSize: int.parse(
                                    assignment.configs != null
                                        ? assignment.configs!
                                            .where((element) =>
                                                element.name ==
                                                "maxsubmissionsizebytes")
                                            .first
                                            .value
                                        : "0"),
                                maxFileCount: int.parse(
                                    assignment.configs != null
                                        ? assignment.configs!
                                            .where((element) =>
                                                element.name ==
                                                "maxfilesubmissions")
                                            .first
                                            .value
                                        : "0"),
                                attempt: attempt,
                                reload: loadAssignmentAttempt,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

Future<Assignment> ReadJsonData(int cmdId, int courseId) async {
  final jsonData = await rootBundle.rootBundle
      .loadString('assets/dummy/all_assignment_course.json');
  final list =
      json.decode(jsonData)['courses'][0]['assignments'] as List<dynamic>;

  List<Assignment> assigns = list.map((e) => Assignment.fromJson(e)).toList();
  // Assignment assign = Assignment();

  // for (var item in assigns) {
  //   if (item.cmid == id) {
  //     assign = item;
  //   }
  // }

  return assigns[0];
}

Future<AttemptAssignment> ReadJsonData2(int cmdId, int courseId) async {
  final jsonData = await rootBundle.rootBundle
      .loadString('assets/dummy/one_assignment_course.json');
  final data = json.decode(jsonData)['lastattempt'] as Map<String, dynamic>;

  AttemptAssignment attempt = AttemptAssignment.fromJson(data);
  return attempt;
}
