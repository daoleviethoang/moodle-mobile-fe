import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:moodle_mobile/data/network/apis/custom_api/custom_api.dart';
import 'package:moodle_mobile/models/course/course_content.dart';
import 'package:moodle_mobile/models/forum/forum_course.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddAssignmentScreen extends StatefulWidget {
  final int courseId;
  final List<CourseContent> sectionList;
  const AddAssignmentScreen(
      {Key? key, required this.courseId, required this.sectionList})
      : super(key: key);

  @override
  State<AddAssignmentScreen> createState() => _AddAssignmentScreenState();
}

class _AddAssignmentScreenState extends State<AddAssignmentScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  // late UserStore _userStore;

  bool isLoading = false;
  late String sectionName;
  late UserStore _userStore;

  DateTime? timeOpen;
  DateTime? timeClose;

  ForumCourse? forumCourse;
  @override
  void initState() {
    super.initState();
    _userStore = GetIt.instance<UserStore>();
    sectionName = widget.sectionList[0].name;
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
              AppLocalizations.of(context)!.add_new_assignment,
              // widget.relyPostId == null
              //     ? AppLocalizations.of(context)!.add_new_discussion
              //     : AppLocalizations.of(context)!.rely_discussion,
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
                          const SizedBox(
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
                                  child: Text(
                                    AppLocalizations.of(context)!.title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
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
                                    controller: nameController,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 1.0, horizontal: 10.0),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(width: 1),
                                      ),
                                      hintText:
                                          AppLocalizations.of(context)!.title,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
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
                                  child: Text(
                                    AppLocalizations.of(context)!.section,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                    width: 500,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.black26,
                                      ),
                                    ),
                                    margin: const EdgeInsets.only(
                                      left: 15,
                                      top: 10,
                                      right: 15,
                                      bottom: 10,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    child: DropdownButton2(
                                      value: sectionName,
                                      onChanged: ((value) {
                                        setState(() {
                                          sectionName = value as String;
                                        });
                                      }),
                                      items: widget.sectionList
                                          .map((e) => DropdownMenuItem<String>(
                                              value: e.name,
                                              child: Text(
                                                e.name,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              )))
                                          .toList(),
                                      buttonHeight: 40,
                                      buttonWidth: 140,
                                      itemHeight: 40,
                                    )),
                              ],
                            ),
                          ),
                          const SizedBox(
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
                                  child: Text(
                                    AppLocalizations.of(context)!.content,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
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
                                        borderSide: const BorderSide(width: 1),
                                      ),
                                      hintText:
                                          AppLocalizations.of(context)!.content,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
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
                                  child: Text(
                                    AppLocalizations.of(context)!.time,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.black26,
                                      ),
                                    ),
                                    width: 500,
                                    margin: const EdgeInsets.only(
                                      left: 15,
                                      top: 10,
                                      right: 15,
                                      bottom: 10,
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Container(
                                                width: 200,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5,
                                                        horizontal: 10),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                    color: Colors.black26,
                                                  ),
                                                ),
                                                child: timeOpen != null
                                                    ? Text(DateFormat(
                                                            'HH:mm dd/MM/yyyy')
                                                        .format(timeOpen!)
                                                        .toString())
                                                    : const Text('')),
                                            TextButton(
                                                onPressed: () {
                                                  DatePicker.showDateTimePicker(
                                                      context,
                                                      showTitleActions: true,
                                                      minTime: DateTime.now(),
                                                      onChanged: (date) {},
                                                      onConfirm: (date) {
                                                    setState(() {
                                                      timeOpen = date;
                                                    });
                                                  },
                                                      currentTime:
                                                          DateTime.now());
                                                },
                                                child: Text(
                                                  AppLocalizations.of(context)!
                                                      .choose_open_time,
                                                  style: const TextStyle(
                                                      color: Colors.blue),
                                                ))
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Container(
                                                width: 200,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5,
                                                        horizontal: 10),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                    color: Colors.black26,
                                                  ),
                                                ),
                                                child: timeClose != null
                                                    ? Text(DateFormat(
                                                            'HH:mm dd/MM/yyyy')
                                                        .format(timeClose!)
                                                        .toString())
                                                    : const Text('')),
                                            TextButton(
                                                onPressed: () {
                                                  DatePicker.showDateTimePicker(
                                                      context,
                                                      showTitleActions: true,
                                                      minTime: DateTime.now(),
                                                      onChanged: (date) {},
                                                      onConfirm: (date) {
                                                    setState(() {
                                                      timeClose = date;
                                                    });
                                                  },
                                                      currentTime:
                                                          DateTime.now());
                                                },
                                                child: Text(
                                                  AppLocalizations.of(context)!
                                                      .choose_close_time,
                                                  style: const TextStyle(
                                                      color: Colors.blue),
                                                ))
                                          ],
                                        )
                                      ],
                                    )),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //print(timeOpen!.millisecondsSinceEpoch * 1000);
          int timeStampOpen = (timeOpen!.millisecondsSinceEpoch / 1000) as int;
          int timeStampEnd = (timeClose!.millisecondsSinceEpoch / 1000) as int;
          int sectionId = widget.sectionList
              .indexWhere((element) => element.name == sectionName);
          await CustomApi().addAssignment(
              _userStore.user.token,
              widget.courseId,
              nameController.text,
              sectionId,
              contentController.text,
              timeStampOpen,
              timeStampEnd);
          Navigator.pop(context, true);
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
