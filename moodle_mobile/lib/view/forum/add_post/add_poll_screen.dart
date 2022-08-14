import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moodle_mobile/data/firebase/firestore/polls_service.dart';
import 'package:moodle_mobile/models/forum/forum_course.dart';
import 'package:moodle_mobile/models/poll/poll.dart';
import 'package:moodle_mobile/view/common/custom_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddPollScreen extends StatefulWidget {
  final int courseId;
  const AddPollScreen({Key? key, required this.courseId}) : super(key: key);

  @override
  State<AddPollScreen> createState() => _AddPollScreenState();
}

class _AddPollScreenState extends State<AddPollScreen> {
  TextEditingController subjectController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  // late UserStore _userStore;
  List<TextEditingController> pollController = [
    TextEditingController(),
    TextEditingController()
  ];
  bool isLoading = false;
  int get numPoll => pollController.length;

  ForumCourse? forumCourse;
  @override
  void initState() {
    super.initState();
    // _userStore = GetIt.instance<UserStore>();
    //load();
  }

  // void load() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   var temp = await ForumApi().getForums(
  //       _userStore.user.token, widget.courseId, widget.forumInstanceId);
  //   if (temp != null) {
  //     setState(() {
  //       forumCourse = temp;
  //     });
  //   }
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            snap: true,
            title: Text(
              AppLocalizations.of(context)!.add_new_poll,
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
                                    AppLocalizations.of(context)!.subject,
                                    style:
                                        const TextStyle(fontWeight: FontWeight.bold),
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
                                        borderSide: const BorderSide(width: 1),
                                      ),
                                      hintText:
                                          AppLocalizations.of(context)!.subject,
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
                                    AppLocalizations.of(context)!.content,
                                    style:
                                        const TextStyle(fontWeight: FontWeight.bold),
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
                                const Padding(padding: EdgeInsets.only(top: 10)),
                                ...List.generate(numPoll, (index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 8.0, left: 5, right: 5),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: PollOption(
                                            controller: pollController[index],
                                          ),
                                        ),
                                        if (numPoll > 2)
                                          IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  pollController
                                                      .removeAt(index);
                                                });
                                              },
                                              icon: const Icon(CupertinoIcons.xmark)),
                                      ],
                                    ),
                                  );
                                }),
                                CustomButtonWidget(
                                  textButton:
                                      AppLocalizations.of(context)!.add_option,
                                  onPressed: () {
                                    setState(() {
                                      pollController
                                          .add(TextEditingController());
                                    });
                                  },
                                )
                              ],
                            ),
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
          pollController.removeWhere((element) => element.text.isEmpty);
          Poll temp = Poll(
            content: contentController.text,
            subject: subjectController.text,
            options: pollController.map((e) => e.text).toList(),
          );
          await PollService.setPoll(widget.courseId.toString(), temp);
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

class PollOption extends StatelessWidget {
  final TextEditingController? controller;
  const PollOption({
    Key? key,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      minLines: 1,
      controller: controller,
      maxLines: 2,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(width: 1),
        ),
        hintText: AppLocalizations.of(context)!.add_option,
      ),
    );
  }
}