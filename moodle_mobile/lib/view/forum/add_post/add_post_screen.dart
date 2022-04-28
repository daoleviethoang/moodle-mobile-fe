import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/data/network/apis/forum/forum_api.dart';
import 'package:moodle_mobile/models/assignment/file_assignment.dart';
import 'package:moodle_mobile/models/forum/forum_course.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/common/chipTitle.dart';
import 'package:moodle_mobile/view/common/custom_button_short.dart';

class AddPostScreen extends StatefulWidget {
  final int forumInstanceId;
  final int courseId;
  final int? relyPostId;
  const AddPostScreen(
      {Key? key,
      required this.forumInstanceId,
      this.relyPostId,
      required this.courseId})
      : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  TextEditingController subjectController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  bool showAdvance = false;
  late UserStore _userStore;
  bool isLoading = false;
  List<FileAssignment> files = [];

  ForumCourse? forumCourse;
  @override
  void initState() {
    super.initState();
    _userStore = GetIt.instance<UserStore>();
    load();
  }

  int caculateByteSize() {
    int sum = 0;
    for (var item in files) {
      sum += item.filesize;
    }
    return sum;
  }

  postToForum() async {
    try {
      if (widget.relyPostId != null) {
        await ForumApi().relyAPost(
          _userStore.user.token,
          widget.relyPostId!,
          subjectController.text,
          contentController.text,
          files,
        );
        Navigator.pop(context);
      } else {
        await ForumApi().postAPost(
          _userStore.user.token,
          widget.forumInstanceId,
          subjectController.text,
          contentController.text,
          files,
        );
        Navigator.pop(context);
      }
    } catch (e) {
      var snackBar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void load() async {
    setState(() {
      isLoading = true;
    });
    var temp = await ForumApi().getForums(
        _userStore.user.token, widget.courseId, widget.forumInstanceId);
    if (temp != null) {
      setState(() {
        forumCourse = temp;
      });
    }
    setState(() {
      isLoading = false;
    });
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
            title: const Text('Overwrite same name file!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    files[index] = FileAssignment(
                        filename: file.name,
                        filepath: file.path ?? "",
                        timeModified: DateTime.now(),
                        filesize: file.size);
                  });

                  // break dialog
                  Navigator.pop(context);
                },
                child: Text("Ok"),
              ),
            ],
          );
        },
      );
      return true;
    }
    return false;
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
              widget.relyPostId == null
                  ? "Add new discussion"
                  : "Rely discussion",
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
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 8, right: 8),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
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
                                  child: const Text(
                                    "Subject",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                                    maxLines: 1,
                                    controller: subjectController,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 1.0, horizontal: 10.0),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: BorderSide(width: 1),
                                      ),
                                      hintText: "Subject",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
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
                                  child: const Text(
                                    "Content",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: BorderSide(width: 1),
                                      ),
                                      hintText: "Content",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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
                              SizedBox(
                                width: 5,
                              ),
                              Icon(showAdvance
                                  ? Icons.arrow_drop_down_sharp
                                  : Icons.arrow_right),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Advance",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    showAdvance
                        ? Container(
                            color: Colors.orange[50],
                            height: 10,
                          )
                        : Container(),
                    showAdvance
                        ? Container(
                            margin: const EdgeInsets.only(left: 8, right: 8),
                            color: Colors.orange[50],
                            alignment: Alignment.centerLeft,
                            child: Wrap(
                              spacing: 2,
                              children: files
                                  .map(
                                    (e) => Container(
                                      margin:
                                          EdgeInsets.only(top: 1, bottom: 1),
                                      child: ChipTile(
                                          label: e.filename,
                                          onDelete: () {
                                            setState(() {
                                              files.remove(e);
                                            });
                                          },
                                          backgroundColor: Colors.blue),
                                    ),
                                  )
                                  .toList(),
                            ),
                          )
                        : Container(),
                    showAdvance
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            height: 300,
                            color: Colors.orange[50],
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CustomButtonShort(
                                    text: "Add file",
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
                                          const snackBar = SnackBar(
                                              content: Text(
                                                  "File's size is bigger"));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                          return;
                                        }
                                        // check number file more than condition
                                        if (files.length ==
                                            (forumCourse?.maxattachments ??
                                                0)) {
                                          const snackBar = SnackBar(
                                              content:
                                                  Text("Number file is full"));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                          return;
                                        }
                                        // check file same name
                                        bool check = checkOverwrite(file);
                                        if (check == true) return;

                                        // add file
                                        files.add(FileAssignment(
                                            filename: file.name,
                                            filepath: file.path ?? "",
                                            timeModified: DateTime.now(),
                                            filesize: file.size));
                                        setState(() {
                                          files.sort(((a, b) => a.filename
                                              .compareTo(b.filename)));
                                        });
                                      }
                                    }),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Kích cỡ tối đa đối với các tập tin mới : ${(forumCourse?.maxbytes ?? 0) / 1024 / 1024} MB.",
                                  maxLines: 3,
                                ),
                                Text(
                                  "Mặc đinh tối đa :${forumCourse?.maxattachments ?? 0} file.",
                                ),
                              ],
                            ),
                          )
                        : Container(),
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
