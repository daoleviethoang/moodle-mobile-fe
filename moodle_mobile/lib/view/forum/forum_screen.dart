import 'package:flutter/material.dart';
import 'package:moodle_mobile/view/forum/add_post/add_post_screen.dart';
import 'package:moodle_mobile/view/forum/forum_detail_screen.dart';
import 'package:moodle_mobile/view/forum/forum_header.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({Key? key}) : super(key: key);

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  void Sort() {
    setState(() {
      sortDesc = !sortDesc;
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
              Text('Name'),
              sortDesc != true
                  ? IconButton(
                      icon: Icon(Icons.arrow_upward),
                      onPressed: Sort,
                    )
                  : IconButton(
                      icon: Icon(Icons.arrow_downward),
                      onPressed: Sort,
                    ),
              Spacer(),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => const AddPostScreen(
                                  forumInstanceId: 1872,
                                  courseId: 1257,
                                )));
                  },
                  icon: Icon(Icons.add)),
            ],
          ),
        ),
<<<<<<< Updated upstream
        PostCard(
          title: 'How to use widgets in flutter',
          value: true,
        ),
        PostCard(
          title: 'How to rm /* like a boss',
          value: false,
          relyNum: 0,
        )
=======
        ..._forumDiscussion.map((e) {
          return PostCard(
            discussionId: e.discussion,
            title: e.name!,
            article: e.userfullname,
            relyNum: e.numreplies!,
            date: DateTime.fromMillisecondsSinceEpoch(e.created! * 1000),
          );
        }),
>>>>>>> Stashed changes
      ],
    );
  }
}

class PostCard extends StatefulWidget {
  final String title;
  final int relyNum;
<<<<<<< Updated upstream
  bool value;
  PostCard(
      {Key? key, required this.title, this.relyNum = 2, required this.value})
=======
  final int? discussionId;
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
>>>>>>> Stashed changes
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ForumHeader(),
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
                    Text('Subscribe'),
                    Spacer(),
                    Text(widget.relyNum.toString() + ' replies'),
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
