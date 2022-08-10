import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/data/network/apis/assignment/assignment_api.dart';
import 'package:moodle_mobile/models/assignment/attemp_assignment.dart';
import 'package:moodle_mobile/models/assignment/feedback.dart';
import 'package:moodle_mobile/models/assignment/file_assignment.dart';
import 'package:moodle_mobile/models/assignment/files_assignment.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/assignment/file_assignment_teacher_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FilesAssignmentTeacherScreen extends StatefulWidget {
  final int assignId;
  final int userId;

  const FilesAssignmentTeacherScreen({
    Key? key,
    required this.assignId,
    required this.userId,
  }) : super(key: key);

  @override
  _FilesAssignmentTeacherScreenState createState() =>
      _FilesAssignmentTeacherScreenState();
}

class _FilesAssignmentTeacherScreenState
    extends State<FilesAssignmentTeacherScreen> {
  AttemptAssignment attempt = AttemptAssignment();
  FeedBack feedBack = FeedBack();
  late UserStore _userStore;
  List<FileUpload> files = [];
  bool isLoading = false;

  void loadAssignment() async {
    setState(() {
      isLoading = true;
    });

    AttemptAssignment temp2 = await readAttempt();
    FeedBack temp3 = await readFeedBack();

    setState(() {
      attempt = temp2;
      feedBack = temp3;
      isLoading = false;
    });
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

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    _userStore = GetIt.instance<UserStore>();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
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
    return Scaffold(
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
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.builder(
                        padding: const EdgeInsets.only(top: 0),
                        shrinkWrap: true,
                        itemCount: files.length,
                        itemBuilder: (BuildContext context, int index) {
                          return FileAssignmentTeacherTile(
                            file: files[index],
                          );
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      feedBack.grade == null
                          ? Column(
                              // if have grade
                              children: [],
                            )
                          : Column(
                              // if don't have grade
                              children: [],
                            ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
