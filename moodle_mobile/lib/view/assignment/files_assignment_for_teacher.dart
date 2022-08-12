import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/constants/dimens.dart';
import 'package:moodle_mobile/data/network/apis/assignment/assignment_api.dart';
import 'package:moodle_mobile/data/network/apis/user/user_api.dart';
import 'package:moodle_mobile/data/network/dio_client.dart';
import 'package:moodle_mobile/di/service_locator.dart';
import 'package:moodle_mobile/models/assignment/attemp_assignment.dart';
import 'package:moodle_mobile/models/assignment/feedback.dart';
import 'package:moodle_mobile/models/assignment/file_assignment.dart';
import 'package:moodle_mobile/models/assignment/files_assignment.dart';
import 'package:moodle_mobile/models/assignment/user_submited.dart';
import 'package:moodle_mobile/models/comment/comment.dart';
import 'package:moodle_mobile/models/user/user_overview.dart';
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
  UserOverview? _userOverview;
  TextEditingController gradeController = TextEditingController();
  TextEditingController commentController = TextEditingController();

  Future loadAssignment() async {
    setState(() {
      isLoading = true;
    });
    AttemptAssignment temp2 = await readAttempt();
    FeedBack temp3 = await readFeedBack();
    if ((temp3.grade?.grader) != null) {
      List<UserOverview> list = await UserApi(getIt<DioClient>())
          .getUserById(_userStore.user.token, temp3.grade!.grader!);
      print(list.toString());
      if (list.isNotEmpty) {
        setState(() {
          _userOverview = list[0];
          gradeController = TextEditingController(
            text: double.tryParse(temp3.grade?.grade ?? "")?.toString() ?? "",
          );
          commentController = TextEditingController(
              text: temp3.plugins?[0].editorfields?[0].text ?? "");
        });
      }
    }

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
              actions: [
                // isLoading == false && widget.usersubmitted.submitted == true
                IconButton(
                    onPressed: () async {
                      var dou = double.tryParse(gradeController.text);
                      if (dou == null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Input grade invalid"),
                          backgroundColor: Colors.red,
                        ));
                        return;
                      }
                      print("auo");
                      var check = await AssignmentApi().saveGrade(
                          _userStore.user.token,
                          widget.assignId,
                          widget.usersubmitted.id ?? 0,
                          dou,
                          commentController.text);
                      if (check == true) {
                        Navigator.pop(context);
                      }
                    },
                    iconSize: Dimens.appbar_icon_size,
                    icon: Icon(CupertinoIcons.checkmark, color: Colors.white))
              ],
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
                          leading: UserAvatarCommon(
                            // imageURL: avatar + "&token=" + userStore.user.token,
                            imageURL: ((widget.usersubmitted.profileimageurl ??
                                        "")
                                    .contains("?"))
                                ? ((widget.usersubmitted.profileimageurl
                                            ?.replaceAll("pluginfile.php",
                                                "webservice/pluginfile.php") ??
                                        "") +
                                    "&token=" +
                                    _userStore.user.token)
                                : ((widget.usersubmitted.profileimageurl
                                            ?.replaceAll("pluginfile.php",
                                                "webservice/pluginfile.php") ??
                                        "") +
                                    "?token=" +
                                    _userStore.user.token),
                          ),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 16,
                                    left: 16,
                                  ),
                                  child: Text("Time remaining",
                                      style: TextStyle(fontSize: 16)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 16,
                                    left: 18,
                                  ),
                                  child: Text(dateDiffSubmit(widget.duedate),
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: MoodleColors.gray)),
                                ),
                                const Padding(
                                    padding: const EdgeInsets.only(
                                        top: 16, left: 16),
                                    child: Text("Editing Status",
                                        style: TextStyle(fontSize: 16))),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 16,
                                    left: 18,
                                  ),
                                  child: Text(
                                      (attempt.caneditowner ?? false)
                                          ? "Student can edit this submission"
                                          : "Student can't edit this submission",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.orange[400])),
                                ),
                                const Padding(
                                    padding: const EdgeInsets.only(
                                        top: 16, left: 16),
                                    child: Text("Last modified",
                                        style: TextStyle(fontSize: 16))),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 16, left: 16),
                                  child: Builder(builder: (context) {
                                    final date =
                                        DateTime.fromMillisecondsSinceEpoch(
                                            (attempt.submission?.timemodified ??
                                                    0) *
                                                1000);
                                    final str = (date ==
                                            DateTime.fromMillisecondsSinceEpoch(
                                                0))
                                        ? "Not modified"
                                        : DateFormat(
                                                "EEEE, dd MMMM yyyy, hh:mmaa",
                                                Localizations.localeOf(context)
                                                    .languageCode)
                                            .format(date);
                                    return Text(str,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: MoodleColors.gray));
                                  }),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 16, left: 16),
                                  child: Text("File submission",
                                      style: TextStyle(fontSize: 16)),
                                ),
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
                                ListTile(
                                  title: Padding(
                                    padding: EdgeInsets.only(top: 4),
                                    child:
                                        Text("Được chấm bởi giáo viên teacher"),
                                  ),
                                  subtitle: Text(
                                    "Comments (" +
                                        (comment.comments?.length.toString() ??
                                            "0") +
                                        ")",
                                    style: TextStyle(color: MoodleColors.blue),
                                  ),
                                  trailing: Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: const Icon(Icons.arrow_forward_ios),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 16, left: 16),
                                  child: Text("Grade out of 100",
                                      style: TextStyle(fontSize: 16)),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 16.0),
                                  child: TextField(
                                    controller: gradeController,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 16, left: 16),
                                  child: Text("Current grade in grade book",
                                      style: TextStyle(fontSize: 16)),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 16, left: 18),
                                  child: Text(
                                      double.tryParse(
                                                  feedBack.grade?.grade ?? "")
                                              ?.toString() ??
                                          "",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: MoodleColors.gray)),
                                ),
                                ListTile(
                                  title: Padding(
                                    padding: EdgeInsets.only(top: 16),
                                    child: Text("Feedback comment",
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                  subtitle: Padding(
                                    padding: EdgeInsets.only(top: 16),
                                    child: TextField(
                                        controller: commentController,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: MoodleColors.gray)),
                                  ),
                                ),
                                feedBack.grade == null
                                    ? Container()
                                    : Padding(
                                        padding: EdgeInsets.only(top: 20.0),
                                        child: ListTile(
                                          onTap: () {},
                                          leading: UserAvatarCommon(
                                              imageURL: ((_userOverview
                                                              ?.profileimageurl ??
                                                          "")
                                                      .contains("?"))
                                                  ? ((_userOverview
                                                              ?.profileimageurl
                                                              ?.replaceAll(
                                                                  "pluginfile.php",
                                                                  "webservice/pluginfile.php") ??
                                                          "") +
                                                      "&token=" +
                                                      _userStore.user.token)
                                                  : ((_userOverview
                                                              ?.profileimageurl
                                                              ?.replaceAll(
                                                                  "pluginfile.php",
                                                                  "webservice/pluginfile.php") ??
                                                          "") +
                                                      "?token=" +
                                                      _userStore.user.token)),
                                          title: Padding(
                                            padding: EdgeInsets.only(top: 4),
                                            child: Text("Grade by teacher" +
                                                (_userOverview?.fullname ??
                                                    "")),
                                          ),
                                          subtitle: Padding(
                                            padding: EdgeInsets.only(top: 8),
                                            child: Builder(builder: (context) {
                                              final date = DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      (feedBack.grade
                                                                  ?.timemodified ??
                                                              0) *
                                                          1000);
                                              final str = (date ==
                                                      DateTime
                                                          .fromMillisecondsSinceEpoch(
                                                              0))
                                                  ? "Not modified"
                                                  : DateFormat(
                                                          "EEEE, dd MMMM yyyy, hh:mmaa",
                                                          Localizations
                                                                  .localeOf(
                                                                      context)
                                                              .languageCode)
                                                      .format(date);
                                              return Text(str,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color:
                                                          MoodleColors.gray));
                                            }),
                                          ),
                                          trailing: Padding(
                                            padding: EdgeInsets.only(top: 15),
                                            child:
                                                Icon(Icons.arrow_forward_ios),
                                          ),
                                        ),
                                      ),
                              ],
                            )
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
