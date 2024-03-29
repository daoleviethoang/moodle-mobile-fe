import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/data/network/apis/forum/forum_api.dart';
import 'package:moodle_mobile/models/forum/forum_discussion.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/common/image_view.dart';
import 'package:moodle_mobile/view/forum/add_post/add_post_screen.dart';
import 'package:moodle_mobile/view/forum/forum_detail_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForumDiscussionScreen extends StatefulWidget {
  final int? forumId;
  final int? courseId;

  const ForumDiscussionScreen({Key? key, this.forumId, this.courseId})
      : super(key: key);

  @override
  State<ForumDiscussionScreen> createState() => _ForumDiscussionScreenState();
}

class _ForumDiscussionScreenState extends State<ForumDiscussionScreen> {
  late UserStore _userStore;
  List<ForumDiscussion> _forumDiscussion = [];

  @override
  void initState() {
    _userStore = GetIt.instance();
    // TODO: implement initState
    super.initState();
    fetch();
  }

  void Sort() {
    setState(() {
      sortDesc = !sortDesc;
      _forumDiscussion.sort(((a, b) {
        if (sortDesc == false) {
          return a.name?.compareTo(b.name ?? "") ?? 0;
        } else {
          return b.name?.compareTo(a.name ?? "") ?? 0;
        }
      }));
    });
  }

  void fetch() async {
    await ForumApi()
        .getForumDiscussion(_userStore.user.token, widget.forumId!)
        .then((value) {
      setState(() {
        _forumDiscussion = value!;
      });
      Sort();
    });
  }

  bool sortDesc = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(AppLocalizations.of(context)!.forum_name),
              sortDesc != true
                  ? IconButton(
                      icon: const Icon(Icons.arrow_upward),
                      onPressed: Sort,
                    )
                  : IconButton(
                      icon: const Icon(Icons.arrow_downward),
                      onPressed: Sort,
                    ),
              const Spacer(),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => AddPostScreen(
                                  forumInstanceId: widget.forumId!,
                                  courseId: widget.courseId!,
                                ))).then((_) {
                      fetch();
                    });
                  },
                  icon: const Icon(Icons.add)),
            ],
          ),
        ),
        ..._forumDiscussion.map((e) {
          return PostCard(
            discussionId: e.discussion,
            title: e.name!,
            article: e.userfullname,
            relyNum: e.numreplies!,
            date: DateTime.fromMillisecondsSinceEpoch(e.created! * 1000),
          );
        }),
      ],
    );
  }
}

class PostCard extends StatefulWidget {
  final int? discussionId;
  final String title;
  final int relyNum;
  final String? article;
  final DateTime? date;
  bool value;
  PostCard(
      {Key? key,
      this.article,
      this.date,
      this.discussionId,
      required this.title,
      this.relyNum = 2,
      this.value = true})
      : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) => ForumDetailScreen(
                      DiscussionId: widget.discussionId,
                    )));
      },
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
                child: Text(
                  widget.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: CircleImageView(
                        imageUrl: '',
                        height: 60,
                        width: 60,
                        placeholder: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.person,
                            size: 35,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      height: 60,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.forum_started,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                widget.article!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: MoodleColors.blue),
                              ),
                            ],
                          ),
                          //SizedBox(height: 20),
                          Text(
                            DateFormat('hh:mm dd-MM-yyyy')
                                .format(widget.date!)
                                .toString(),
                            style: const TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Checkbox(
                      value: widget.value,
                      onChanged: (value) {
                        setState(() {
                          widget.value = value!;
                        });
                      },
                    ),
                    Text(AppLocalizations.of(context)!.forum_subscrible),
                    const Spacer(),
                    Text(widget.relyNum.toString() +
                        AppLocalizations.of(context)!.forum_replies),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}