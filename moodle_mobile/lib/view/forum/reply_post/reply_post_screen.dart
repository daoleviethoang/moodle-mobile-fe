import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/data/network/apis/forum/forum_api.dart';
import 'package:moodle_mobile/models/assignment/file_assignment.dart';
import 'package:moodle_mobile/models/forum/forum_course.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/common/chipTitle.dart';
import 'package:moodle_mobile/view/common/custom_button_short.dart';
import 'package:moodle_mobile/view/common/image_view.dart';

class ReplyPostScreen extends StatefulWidget {
  final String? article;
  final int? timeCreated;
  final String? content;
  final String? subject;
  final int? relyPostId;
  const ReplyPostScreen(
      {Key? key,
      this.article,
      this.content,
      this.timeCreated,
      this.relyPostId,
      this.subject})
      : super(key: key);

  @override
  State<ReplyPostScreen> createState() => _ReplyPostScreenState();
}

class _ReplyPostScreenState extends State<ReplyPostScreen> {
  TextEditingController contentController = TextEditingController();
  bool showAdvance = false;
  late UserStore _userStore;
  bool isLoading = false;
  List<FileUpload> files = [];

  @override
  Widget build(BuildContext context) {
    ForumCourse? forumCourse;

    postToForum() async {
      try {
        _userStore = GetIt.instance();
        await ForumApi().relyAPost(
          _userStore.user.token,
          widget.relyPostId!,
          widget.subject!,
          contentController.text,
          files,
        );
        Navigator.pop(context);
      } catch (e) {
        var snackBar = SnackBar(content: Text(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

    int caculateByteSize() {
      int sum = 0;
      for (var item in files) {
        sum += item.filesize;
      }
      return sum;
    }

    bool checkOverwrite(PlatformFile file) {
      int index = -1;
      for (var i = 0; i < files.length; i++) {
        if (files[i].filename == file.name) {
          index = i;
          break;
        }
      }
      if (index != -1) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.override_file),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context)!.cancel),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      files[index] = FileUpload(
                          filename: file.name,
                          filepath: file.path ?? "",
                          timeModified: DateTime.now(),
                          filesize: file.size);
                    });

                    // break dialog
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context)!.ok),
                ),
              ],
            );
          },
        );
        return true;
      }
      return false;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.replying),
        leading: TextButton(
          style: TextButton.styleFrom(
            primary: Colors.white,
          ),
          child: const Icon(CupertinoIcons.back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              ReplyBox(
                article: widget.article,
                timeCreated: widget.timeCreated,
                content: widget.content,
              ),
              Card(
                elevation: 10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        left: 15,
                        top: 20,
                        right: 15,
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.text_reply,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        left: 15,
                        top: 10,
                        right: 15,
                        bottom: 10,
                      ),
                      child: TextField(
                        minLines: 6,
                        maxLines: 10,
                        controller: contentController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(width: 1),
                          ),
                          hintText: AppLocalizations.of(context)!.text_reply,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              //advance
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      showAdvance = !showAdvance;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 3,
                      bottom: 3,
                    ),
                    color: Colors.orange[100],
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 5,
                        ),
                        Icon(showAdvance
                            ? Icons.arrow_drop_down_sharp
                            : Icons.arrow_right),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          AppLocalizations.of(context)!.advance,
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (showAdvance)
                Container(
                  color: Colors.orange[50],
                  height: 10,
                ),
              if (showAdvance)
                Container(
                  margin: const EdgeInsets.only(left: 8, right: 8),
                  color: Colors.orange[50],
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: 2,
                    children: files
                        .map(
                          (e) => Container(
                            margin: const EdgeInsets.only(top: 1, bottom: 1),
                            child: ChipTile(
                                label: e.filename,
                                onDelete: () {
                                  setState(() {
                                    files.remove(e);
                                  });
                                },
                                backgroundColor: MoodleColors.blue),
                          ),
                        )
                        .toList(),
                  ),
                ),
              if (showAdvance)
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  color: Colors.orange[50],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomButtonShort(
                          text: AppLocalizations.of(context)!.add_file,
                          textColor: Colors.white,
                          bgColor: MoodleColors.blue,
                          blurRadius: 1,
                          onPressed: () async {
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles();
                            if (result != null) {
                              PlatformFile file = result.files.first;
                              // check size more than condition
                              if (file.size + caculateByteSize() >
                                  (forumCourse?.maxbytes ?? 0)) {
                                var snackBar = SnackBar(
                                    content: Text(AppLocalizations.of(context)!
                                        .file_size_bigger));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                                return;
                              }
                              // check number file more than condition
                              if (files.length ==
                                  (forumCourse?.maxattachments ?? 0)) {
                                var snackBar = SnackBar(
                                    content: Text(AppLocalizations.of(context)!
                                        .number_file_full));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                                return;
                              }
                              // check file same name
                              bool check = checkOverwrite(file);
                              if (check == true) return;

                              // add file
                              files.add(FileUpload(
                                  filename: file.name,
                                  filepath: file.path ?? "",
                                  timeModified: DateTime.now(),
                                  filesize: file.size));
                              setState(() {
                                files.sort(((a, b) =>
                                    a.filename.compareTo(b.filename)));
                              });
                            }
                          }),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        AppLocalizations.of(context)!.max_file_size +
                            "${(forumCourse?.maxbytes ?? 0) / 1024 / 1024} MB.",
                        maxLines: 3,
                      ),
                      Text(
                        AppLocalizations.of(context)!.default_num_file +
                            "${forumCourse?.maxattachments ?? 0} file.",
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          postToForum();
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(
          Icons.check,
          color: Colors.white,
        ),
      ),
    );
  }
}

class ReplyBox extends StatelessWidget {
  final String? article;
  final int? timeCreated;
  final String? content;
  const ReplyBox({Key? key, this.article, this.timeCreated, this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: CircleImageView(
                        imageUrl: '',
                        height: 60,
                        width: 60,
                        placeholder: Icon(
                          Icons.person,
                          size: 33,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        article!,
                        style: const TextStyle(color: MoodleColors.blue),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Html(data: content!),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  DateFormat('hh:mm dd-MM-yyyy')
                      .format(DateTime.fromMillisecondsSinceEpoch(
                          timeCreated! * 1000))
                      .toString(),
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
