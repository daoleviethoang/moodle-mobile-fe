import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:moodle_mobile/view/common/content_item.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:moodle_mobile/data/network/apis/forum/forum_api.dart';
import 'package:moodle_mobile/models/forum/forum_post.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/common/content_item.dart';
import 'package:moodle_mobile/view/common/image_view.dart';

class ForumDetailScreen extends StatefulWidget {
  final int? DiscussionId;
  const ForumDetailScreen({Key? key, this.DiscussionId}) : super(key: key);

  @override
  State<ForumDetailScreen> createState() => _ForumDetailScreenState();
}

class _ForumDetailScreenState extends State<ForumDetailScreen> {
  bool isLoading = false;
  List<ForumPost> _forumPost = [];
  late UserStore _userStore;

  @override
  void initState() {
    _userStore = GetIt.instance();
    // TODO: implement initState
    super.initState();
    fetch();
  }

  fetch() async {
    await ForumApi()
        .getForumPost(_userStore.user.token, widget.DiscussionId!)
        .then((value) {
      setState(() {
        _forumPost = value!;
        isLoading = !isLoading;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    int len = _forumPost.length;
    return !isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                title: Text(
              _forumPost[len - 1].subject!,
              maxLines: 2,
            )),
            body: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: CircleImageView(
                              imageUrl: '',
                              height: 60,
                              width: 60,
                              placeholder: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.person,
                                  size: 35,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            height: 60,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  _forumPost[len - 1].author!.fullname!,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue),
                                ),
                                //SizedBox(height: 20),
                                Text(
                                  DateFormat('hh:mm dd-MM-yyyy')
                                      .format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              _forumPost[len - 1].timecreated! *
                                                  1000))
                                      .toString(),
                                  style: TextStyle(fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Html(
                      data: _forumPost[len - 1].message,
                      // data: "<div>"
                      //     "<h1>Demo Page</h1>"
                      //     "<p>This is a fantastic product that you should buy!</p>"
                      //     "<h3>Features</h3>"
                      //     "<ul>"
                      //     "<li>It actually works</li>"
                      //     "<li>It exists</li>"
                      //     "<li>It doesn't cost much!</li>"
                      //     "</ul>"
                      //     "</div>",
                      // style: {
                      //   'h1': Style(fontSize: const FontSize(19)),
                      //   'h2': Style(fontSize: const FontSize(17.5)),
                      //   'h3': Style(fontSize: const FontSize(16)),
                      // },
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ...List.generate(
                              _forumPost[len - 1].attachments!.length, (index) {
                            var temp = _forumPost[len - 1].attachments![index];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: AttachmentItem(
                                title: temp != null ? temp.filename! : ' ',
                                attachmentUrl: '',
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    Divider(),
                    ListView.builder(
                        padding: EdgeInsets.only(bottom: 30),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: _forumPost.length - 1,
                        itemBuilder: (BuildContext, index) {
                          bool checkReply;
                          if (_forumPost[len - 2 - index].parentid ==
                              _forumPost[len - 1].id)
                            checkReply = false;
                          else
                            checkReply = true;
                          return ReplyCard(
                            isReply: checkReply,
                            date: _forumPost[len - 2 - index].timecreated,
                            name: _forumPost[len - 2 - index].author!.fullname,
                            message: _forumPost[len - 2 - index].message,
                            subject: _forumPost[len - 2 - index].subject,
                          );
                        })
                  ],
                ),
              ),
            ),
          );
  }
}

class ReplyCard extends StatelessWidget {
  final bool? isReply;
  final String? subject;
  final int? date;
  final String? name;
  final String? message;
  const ReplyCard(
      {Key? key,
      this.isReply,
      this.date,
      this.message,
      this.name,
      this.subject})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment:
            isReply == false ? Alignment.centerLeft : Alignment.centerRight,
        child: SizedBox(
          width: isReply == false
              ? double.infinity
              : MediaQuery.of(context).size.width * 0.8,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      subject!,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.green),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      children: [
                        Text('by '),
                        Text(
                          name!,
                          style: TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      DateFormat('hh:mm dd-MM-yyyy')
                          .format(
                              DateTime.fromMillisecondsSinceEpoch(date! * 1000))
                          .toString(),
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Html(data: message!),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.message),
                        SizedBox(
                          width: 5,
                        ),
                        Text('Reply'),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
