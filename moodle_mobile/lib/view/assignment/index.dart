import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/data/network/apis/assignment/assignment_api.dart';
import 'package:moodle_mobile/data/network/apis/contact/contact_service.dart';
import 'package:moodle_mobile/models/assignment/assignment.dart';
import 'package:moodle_mobile/models/assignment/attemp_assignment.dart';
import 'package:moodle_mobile/models/assignment/feedback.dart';
import 'package:moodle_mobile/models/assignment/user_submited.dart';
import 'package:moodle_mobile/models/contact/contact.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/assignment/date_assignment_tile.dart';
import 'package:moodle_mobile/view/assignment/files_assignment.dart';
import 'package:moodle_mobile/view/assignment/list_user_submit.dart';
import 'package:moodle_mobile/view/assignment/submission_status_tile.dart';
import 'package:moodle_mobile/view/common/custom_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AssignmentScreen extends StatefulWidget {
  final int assignInstanceId;
  final int courseId;
  final String title;
  final bool? isTeacher;

  const AssignmentScreen({
    Key? key,
    required this.assignInstanceId,
    required this.courseId,
    required this.title,
    required this.isTeacher,
  }) : super(key: key);

  @override
  _AssignmentScreenState createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  Assignment assignment = Assignment();
  AttemptAssignment attempt = AttemptAssignment();
  List<UserSubmited> users = [];
  List<UserSubmited> userSubmiteds = [];
  List<UserSubmited> userSubmitedNeedGrade = [];
  bool isLoading = false;
  String dateDiff = "";
  Color dateDiffColor = Colors.grey;
  late UserStore _userStore;
  bool overDue = false;
  bool error = false;
  FeedBack feedback = FeedBack();
  late Timer _timer;
  bool isTeacher = false;

  @override
  void initState() {
    _userStore = GetIt.instance<UserStore>();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        dateDiffSubmit();
      });
    });
    if (widget.isTeacher != null) {
      isTeacher = widget.isTeacher!;
    } else {
      checkIsTeacher();
    }

    super.initState();
    loadAssignment();
  }

  checkIsTeacher() async {
    List<Contact> contacts = await ContactService()
        .getContacts(_userStore.user.token, widget.courseId);
    if (contacts.any((element) => element.id == _userStore.user.id)) {
      setState(() {
        isTeacher = true;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
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
      setState(() {
        error = true;
      });
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
      setState(() {
        error = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
    }
    return AttemptAssignment();
  }

  Future<FeedBack> readFeedBack(int assignInstanceId) async {
    try {
      FeedBack feedBack = await AssignmentApi().getAssignmentFeedbackAndGrade(
          _userStore.user.token, assignInstanceId);
      return feedBack;
    } catch (e) {
      setState(() {
        error = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
    }
    return FeedBack();
  }

  Future<List<UserSubmited>> readUserSubmited(int assignInstanceId) async {
    try {
      List<UserSubmited> users = await AssignmentApi()
          .getListUserSubmit(_userStore.user.token, assignInstanceId);
      return users;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
    }
    return [];
  }

  void loadAssignment() async {
    setState(() {
      isLoading = true;
    });
    Assignment temp = await ReadData(widget.assignInstanceId, widget.courseId);

    AttemptAssignment temp2 = isTeacher == true
        ? AttemptAssignment()
        : await ReadData2(widget.assignInstanceId);
    FeedBack temp3 = isTeacher == true
        ? FeedBack()
        : await readFeedBack(widget.assignInstanceId);

    getListUserSubmit();

    setState(() {
      assignment = temp;
      attempt = temp2;
      feedback = temp3;
      isLoading = false;
    });
    dateDiffSubmit();
  }

  void getListUserSubmit() async {
    if (isTeacher == true) {
      List<UserSubmited> temp4 =
          await readUserSubmited(widget.assignInstanceId);
      setState(() {
        users = temp4;
        userSubmiteds =
            temp4.where((element) => element.submitted == true).toList();
        userSubmitedNeedGrade = temp4
            .where((element) =>
                element.submitted == true && element.requiregrading == true)
            .toList();
      });
    }
  }

  void loadAssignmentAttempt() async {
    AttemptAssignment temp2 = await ReadData2(widget.assignInstanceId);
    setState(() {
      attempt = temp2;
    });
  }

  dateDiffSubmit() {
    if (assignment.duedate == null) {
      return;
    }
    DateTime dueDate =
        DateTime.fromMillisecondsSinceEpoch((assignment.duedate ?? 0) * 1000);
    var zero = DateTime(0);

    if ((attempt.submission?.status ?? 'new') == 'new') {
      Duration duration = dueDate.difference(DateTime.now());
      final dateTime = zero.add(duration.abs());
      int day = dateTime.day - 1;
      setState(() {
        dateDiff = (dueDate.isAfter(DateTime.now())
                ? AppLocalizations.of(context)!.due_in
                : AppLocalizations.of(context)!.overdue_by) +
            " " +
            ((day > 0)
                ? (duration.inDays.abs().toString() +
                    " " +
                    AppLocalizations.of(context)!.days +
                    " " +
                    dateTime.hour.toString() +
                    " " +
                    AppLocalizations.of(context)!.hours)
                : ((duration.inMinutes.abs() > 0)
                    ? (dateTime.hour.toString() +
                        " " +
                        AppLocalizations.of(context)!.hours +
                        " " +
                        dateTime.minute.toString() +
                        " " +
                        AppLocalizations.of(context)!.minutes)
                    : dateTime.second.toString() +
                        " " +
                        AppLocalizations.of(context)!.seconds));
        overDue = (dueDate.isAfter(DateTime.now()) ? false : true) &&
            (attempt.cansubmit == false || attempt.cansubmit == null);
      });
      return;
    }

    DateTime modifi = DateTime.fromMillisecondsSinceEpoch(
        (attempt.submission?.timemodified ?? 0) * 1000);
    Duration duration = dueDate.difference(modifi);
    final dateTime = zero.add(duration.abs());
    int day = dateTime.day - 1;
    setState(() {
      dateDiff = AppLocalizations.of(context)!.submitted +
          " " +
          ((day > 0)
              ? (duration.inDays.abs().toString() +
                  " " +
                  AppLocalizations.of(context)!.days +
                  " " +
                  dateTime.hour.toString() +
                  " " +
                  AppLocalizations.of(context)!.hours)
              : ((duration.inMinutes.abs() > 0)
                  ? (dateTime.hour.toString() +
                      " " +
                      AppLocalizations.of(context)!.hours +
                      " " +
                      dateTime.minute.toString() +
                      " " +
                      AppLocalizations.of(context)!.minutes)
                  : dateTime.second.toString() +
                      " " +
                      AppLocalizations.of(context)!.seconds)) +
          " " +
          (duration.isNegative
              ? AppLocalizations.of(context)!.late
              : AppLocalizations.of(context)!.early);
      dateDiffColor = duration.isNegative ? Colors.red : Colors.green;
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
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : error
                ? const Center(
                    child: Text("Error loading"),
                  )
                : isTeacher
                    ? SingleChildScrollView(
                        child: Container(
                          margin: const EdgeInsets.only(
                              left: 10, right: 10, top: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              assignment.allowsubmissionsfromdate == null
                                  ? Container()
                                  : DateAssignmentTile(
                                      date: (assignment
                                                  .allowsubmissionsfromdate ??
                                              0) *
                                          1000,
                                      title:
                                          AppLocalizations.of(context)!.opened,
                                      iconColor: Colors.grey,
                                      backgroundIconColor: const Color.fromARGB(
                                          255, 217, 217, 217),
                                    ),
                              assignment.duedate == null
                                  ? Container()
                                  : DateAssignmentTile(
                                      date: (assignment.duedate ?? 0) * 1000,
                                      title: AppLocalizations.of(context)!.due,
                                      iconColor: Colors.green,
                                      backgroundIconColor: Colors.greenAccent,
                                    ),
                              const Divider(),
                              ListTile(
                                tileColor: MoodleColors.white,
                                onTap: users.isEmpty
                                    ? null
                                    : () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(builder: (_) {
                                          return ListUserSubmited(
                                            userSubmiteds: users,
                                            title: widget.title,
                                            haveCheckBox: true,
                                            assignmentId:
                                                widget.assignInstanceId,
                                          );
                                        }));
                                      },
                                title: Text(AppLocalizations.of(context)!
                                    .number_student),
                                trailing: Text(users.length.toString()),
                              ),
                              ListTile(
                                tileColor: MoodleColors.white,
                                onTap: userSubmiteds.isEmpty
                                    ? null
                                    : () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(builder: (_) {
                                          return ListUserSubmited(
                                            userSubmiteds: userSubmiteds,
                                            title: widget.title,
                                            haveCheckBox: false,
                                            assignmentId:
                                                widget.assignInstanceId,
                                          );
                                        }));
                                      },
                                title: Text(AppLocalizations.of(context)!
                                    .number_submission),
                                trailing: Text(userSubmiteds.length.toString()),
                              ),
                              ListTile(
                                tileColor: MoodleColors.white,
                                onTap: userSubmitedNeedGrade.isEmpty
                                    ? null
                                    : () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(builder: (_) {
                                          return ListUserSubmited(
                                            userSubmiteds:
                                                userSubmitedNeedGrade,
                                            title: widget.title,
                                            haveCheckBox: false,
                                            assignmentId:
                                                widget.assignInstanceId,
                                          );
                                        }));
                                      },
                                title: Text(AppLocalizations.of(context)!
                                    .number_wait_grade),
                                trailing: Text(
                                    userSubmitedNeedGrade.length.toString()),
                              ),
                            ],
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        child: Container(
                          margin: const EdgeInsets.only(
                              left: 10, right: 10, top: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              assignment.allowsubmissionsfromdate == null
                                  ? Container()
                                  : DateAssignmentTile(
                                      date: (assignment
                                                  .allowsubmissionsfromdate ??
                                              0) *
                                          1000,
                                      title:
                                          AppLocalizations.of(context)!.opened,
                                      iconColor: Colors.grey,
                                      backgroundIconColor: const Color.fromARGB(
                                          255, 217, 217, 217),
                                    ),
                              assignment.duedate == null
                                  ? Container()
                                  : DateAssignmentTile(
                                      date: (assignment.duedate ?? 0) * 1000,
                                      title: AppLocalizations.of(context)!.due,
                                      iconColor: Colors.green,
                                      backgroundIconColor: Colors.greenAccent,
                                    ),
                              const Divider(),
                              const SizedBox(
                                height: 5,
                              ),
                              if (assignment.intro?.isNotEmpty == true) ...[
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Card(
                                    elevation: 5,
                                    child: Html(
                                      data: assignment.intro ?? "",
                                      shrinkWrap: true,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                              Text(
                                AppLocalizations.of(context)!.submission_status,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              SubmissionStatusTile(
                                leftText: AppLocalizations.of(context)!
                                    .submission_status,
                                rightText: AppLocalizations.of(context)!
                                    .submit_for_grade,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              SubmissionStatusTile(
                                leftText: AppLocalizations.of(context)!
                                    .grading_status,
                                rightText: feedback.grade?.grade ??
                                    AppLocalizations.of(context)!.not_graded,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              SubmissionStatusTile(
                                  leftText:
                                      AppLocalizations.of(context)!.time_remain,
                                  rightText: dateDiff,
                                  rightTextColor: dateDiffColor),
                              const SizedBox(
                                height: 15,
                              ),
                              SubmissionStatusTile(
                                  leftText: AppLocalizations.of(context)!
                                      .last_modified,
                                  rightText: DateFormat(
                                          "hh:mmaa, dd MMMM, yyyy")
                                      .format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              attempt.submission
                                                      ?.timemodified ??
                                                  0))),
                              const SizedBox(
                                height: 15,
                              ),
                              SubmissionStatusTile(
                                leftText: AppLocalizations.of(context)!
                                    .file_submission,
                                rightText: (attempt.submission?.plugins?[0]
                                                .fileareas?[0].files ??
                                            [])
                                        .length
                                        .toString() +
                                    " files",
                                rightTextColor: MoodleColors.blue,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              SubmissionStatusTile(
                                leftText: AppLocalizations.of(context)!
                                    .submission_comments,
                                rightText:
                                    (feedback.plugins?.length ?? 0).toString() +
                                        " " +
                                        AppLocalizations.of(context)!.comments +
                                        "...",
                                rightTextColor: MoodleColors.blue,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              overDue
                                  ? Container()
                                  : CustomButtonWidget(
                                      textButton: (attempt
                                                      .submission
                                                      ?.plugins?[0]
                                                      .fileareas?[0]
                                                      .files ??
                                                  [])
                                              .isEmpty
                                          ? AppLocalizations.of(context)!
                                              .submit_file
                                          : AppLocalizations.of(context)!
                                              .view_file_submission,
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) {
                                              return FilesAssignmentScreen(
                                                assignId:
                                                    widget.assignInstanceId,
                                                dueDate:
                                                    assignment.duedate ?? 0,
                                                canEdit:
                                                    attempt.canedit ?? false,
                                                maxByteSize: int.parse(assignment
                                                            .configs !=
                                                        null
                                                    ? assignment.configs!
                                                        .where((element) =>
                                                            element.name ==
                                                            "maxsubmissionsizebytes")
                                                        .first
                                                        .value
                                                    : "5242880"),
                                                maxFileCount: int.parse(assignment
                                                            .configs !=
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
