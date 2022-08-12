import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/data/network/apis/assignment/assignment_api.dart';
import 'package:moodle_mobile/models/assignment/attemp_assignment.dart';
import 'package:moodle_mobile/models/assignment/feedback.dart';
import 'package:moodle_mobile/models/assignment/file_assignment.dart';
import 'package:moodle_mobile/models/assignment/files_assignment.dart';
import 'package:moodle_mobile/models/assignment/user_submited.dart';
import 'package:moodle_mobile/models/comment/comment.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moodle_mobile/view/assignment/file_assignment_teacher_tile.dart';
import 'package:moodle_mobile/view/common/custom_button_short.dart';
import 'package:moodle_mobile/view/common/user/user_avatar_common.dart';

class FilesAssignmentTeacherScreen extends StatefulWidget {
  final int assignId;
  final int userId;
  final int duedate;
  final UserSubmited usersubmitted;
  final int assignmentModuleId;

  const FilesAssignmentTeacherScreen({
    Key? key,
    required this.duedate,
    required this.assignId,
    required this.userId,
    required this.usersubmitted,
    required this.assignmentModuleId,
  }) : super(key: key);

  @override
  _FilesAssignmentTeacherScreenState createState() =>
      _FilesAssignmentTeacherScreenState();
}

class _FilesAssignmentTeacherScreenState
    extends State<FilesAssignmentTeacherScreen> {
  AttemptAssignment attempt = AttemptAssignment();
  FeedBack feedBack = FeedBack();
  Comment comment = Comment();
  late UserStore _userStore;
  List<FileUpload> files = [];
  bool isLoading = false;

  Future loadAssignment() async {
    setState(() {
      isLoading = true;
    });
    AttemptAssignment temp2 = await readAttempt();
    FeedBack temp3 = await readFeedBack();

    if (widget.assignmentModuleId != 0 && temp2.submission?.id != 0) {
      Comment _comment =
          await readComment(widget.assignmentModuleId, temp2.submission!.id!);
      setState(() {
        comment = _comment;
      });
    }

    setState(() {
      attempt = temp2;
      feedBack = temp3;
      isLoading = false;
    });
  }

  Future<Comment> readComment(int assignCmdId, int submissionId) async {
    try {
      Comment _comment = await AssignmentApi().getAssignmentComment(
          _userStore.user.token, assignCmdId, submissionId, 0);
      return _comment;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
    }
    return Comment();
  }

  Future<AttemptAssignment> readAttempt() async {
    try {
      AttemptAssignment assign = await AssignmentApi().getAssignmentOfStudent(
        _userStore.user.token,
        widget.assignId,
        widget.userId,
      );

      return assign;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
    }
    return AttemptAssignment();
  }

  Future<FeedBack> readFeedBack() async {
    try {
      FeedBack feedBack =
          await AssignmentApi().getAssignmentFeedbackAndGradeOfStudent(
        _userStore.user.token,
        widget.assignId,
        widget.userId,
      );
      return feedBack;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
    }
    return FeedBack();
  }

  dateDiffSubmit(int duedate) {
    DateTime dueDate = DateTime.fromMillisecondsSinceEpoch(duedate * 1000);
    var zero = DateTime(0);

    if ((attempt.submission?.status ?? 'new') == 'new') {
      Duration duration = dueDate.difference(DateTime.now());
      final dateTime = zero.add(duration.abs());
      int day = dateTime.day - 1;

      return (dueDate.isAfter(DateTime.now())
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
    }

    DateTime modifi = DateTime.fromMillisecondsSinceEpoch(
        (attempt.submission?.timemodified ?? 0) * 1000);
    Duration duration = dueDate.difference(modifi);
    final dateTime = zero.add(duration.abs());
    int day = dateTime.day - 1;
    return AppLocalizations.of(context)!.submitted +
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
  }

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    _userStore = GetIt.instance<UserStore>();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await loadAssignment();
      for (Files item
          in attempt.submission?.plugins?[0].fileareas?[0].files ?? []) {
        if (item.fileurl != null) {
          setState(() {
            files.add(FileUpload(
                filename: item.filename ?? "",
                filepath: "",
                filesize: item.filesize ?? 0,
                timeModified: DateTime.fromMillisecondsSinceEpoch(
                    item.timemodified! * 1000),
                fileUrl: item.fileurl ?? ""));
          });
        }
      }
      setState(() {
        isLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              floating: true,
              snap: true,
              title: Text(
                AppLocalizations.of(context)!.submission,
                style: TextStyle(
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
                    margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: const UserAvatarCommon(
                              // imageURL: avatar + "&token=" + userStore.user.token,
                              imageURL:
                                  "https://www.w3schools.com/w3css/lights.jpg"),
                          title: Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 4),
                            child: Text(
                              widget.usersubmitted.fullname ?? "",
                            ),
                          ),
                          subtitle: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              widget.usersubmitted.requiregrading == false &&
                                      widget.usersubmitted.submitted == true
                                  ? Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        color: Colors.green[900],
                                      ),
                                      padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          bottom: 5,
                                          top: 5),
                                      child: const Text(
                                        'Đã chấm điểm',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  : Container(),
                              widget.usersubmitted.submitted == false
                                  ? Container(
                                      margin: const EdgeInsets.only(left: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        color: Colors.red[900],
                                      ),
                                      padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          bottom: 5,
                                          top: 5),
                                      child: const Text(
                                        'Không có bài nộp',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  : Container(),
                              widget.usersubmitted.submitted == true
                                  ? Container(
                                      margin: const EdgeInsets.only(left: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        color: Colors.green[900],
                                      ),
                                      padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          bottom: 5,
                                          top: 5),
                                      child: const Text(
                                        'Đã nộp đẻ chấm điểm',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  : Container()
                            ],
                          ),
                        ),

                        const TabBar(
                          tabs: [
                            Tab(child: Text("Bài nộp")),
                            Tab(child: Text("Điểm")),
                          ],
                          labelColor: Colors.black,
                          indicatorColor: Colors.orange,
                          indicatorWeight: 3,
                        ),

                        Expanded(
                          flex: 1,
                          child: TabBarView(children: [
                            Column(
                              children: [
                                ListView.builder(
                                  padding: const EdgeInsets.only(top: 0),
                                  shrinkWrap: true,
                                  itemCount: files.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return FileAssignmentTeacherTile(
                                      file: files[index],
                                    );
                                  },
                                ),
                              ],
                            ),
                            const Expanded(child: Text("123"))
                          ]),
                        )

                        // const SizedBox(
                        //   height: 10,
                        // ),
                        // feedBack.grade == null
                        //     ? Column(
                        //         // if have grade
                        //         children: [],
                        //       )
                        //     : Column(
                        //         // if don't have grade
                        //         children: [],
                        //       ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
