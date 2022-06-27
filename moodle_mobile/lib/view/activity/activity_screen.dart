import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/data/network/apis/custom_api/custom_api.dart';
import 'package:moodle_mobile/data/network/apis/file/file_api.dart';
import 'package:moodle_mobile/models/assignment/file_assignment.dart';
import 'package:moodle_mobile/models/course/course_content.dart';
import 'package:moodle_mobile/models/module/module.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/activity/album_tile.dart';
import 'package:moodle_mobile/view/common/custom_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ActivityScreen extends StatefulWidget {
  final int sectionIndex;
  final CourseContent? content;
  final bool isTeacher;
  final int courseId;
  final Function(bool) reGetContent;
  const ActivityScreen({
    Key? key,
    required this.sectionIndex,
    required this.isTeacher,
    required this.content,
    required this.reGetContent,
    required this.courseId,
  }) : super(key: key);

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  List<Module> albums = [];
  late UserStore _userStore;
  bool isLoading = false;
  @override
  void initState() {
    _userStore = GetIt.instance<UserStore>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.content == null && widget.isTeacher == true) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: Text(
                AppLocalizations.of(context)!.class_activities,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: MoodleColors.black80,
                ),
                textScaleFactor: 1.5,
              )),
          Center(
            child: CustomButtonWidget(
              textButton: AppLocalizations.of(context)!.create_section_activity,
              onPressed: () async {
                try {
                  await CustomApi().addSectionCourse(
                      _userStore.user.token, widget.courseId, "Activity");
                  await widget.reGetContent(true);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(e.toString()),
                      backgroundColor: Colors.red));
                }
              },
            ),
          ),
        ],
      );
    }
    albums.clear();
    for (Module module in widget.content?.modules ?? []) {
      if (module.modname == ModuleName.folder && module.contents != null) {
        albums.add(module);
      }
    }
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.class_activities,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: MoodleColors.black80,
                  ),
                  textScaleFactor: 1.5,
                ),
                widget.isTeacher == false ? Container() : IconButton(
                    onPressed: () async {
                      try {
                        FilePickerResult? result = await FilePicker.platform
                            .pickFiles(
                                allowMultiple: true, type: FileType.image);
                        if (result != null) {
                          List<FileUpload> files = result.files
                              .map(
                                (e) => FileUpload(
                                  filename: e.name,
                                  filepath: e.path ?? "",
                                  filesize: e.size,
                                  timeModified: DateTime.now(),
                                ),
                              )
                              .toList();

                          int? itemId = await FileApi()
                              .uploadMultipleFile(_userStore.user.token, files);

                          // set in web
                          //int itemId = 429429131;

                          if (itemId != null) {
                            if (albums.any((element) =>
                                element.name ==
                                DateFormat("dd/MM/yyyy")
                                    .format(DateTime.now()))) {
                              await CustomApi().addModuleFolder(
                                  _userStore.user.token,
                                  widget.courseId,
                                  DateFormat("dd/MM/yyyy hh:mm:ss")
                                      .format(DateTime.now()),
                                  widget.sectionIndex,
                                  itemId);
                            } else {
                              await CustomApi().addModuleFolder(
                                  _userStore.user.token,
                                  widget.courseId,
                                  DateFormat("dd/MM/yyyy")
                                      .format(DateTime.now()),
                                  widget.sectionIndex,
                                  itemId);
                            }
                            setState(() {
                              isLoading = true;
                            });
                            await widget.reGetContent(true);
                            setState(() {
                              isLoading = false;
                            });
                          }
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(e.toString()),
                            backgroundColor: Colors.red));
                      }
                    },
                    icon: Icon(Icons.add)),
              ],
            )),
        (widget.content?.modules.isEmpty ?? true)
            ? Center(
                child: Text(AppLocalizations.of(context)!.empty_data),
              )
            : Column(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: albums
                          .map((e) => AlbumTile(
                                module: e,
                                courseId: widget.courseId,
                                isTeacher: widget.isTeacher,
                                reGetContent: widget.reGetContent,
                                sectionIndex: widget.sectionIndex,
                                userStore: _userStore,
                              ))
                          .toList(),
                    ),
                  ),
                  isLoading ? const CircularProgressIndicator() : Container()
                ],
              ),
      ],
    );
  }
}
