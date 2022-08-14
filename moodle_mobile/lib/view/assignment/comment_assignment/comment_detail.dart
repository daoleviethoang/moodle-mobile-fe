import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moodle_mobile/constants/dimens.dart';
import 'package:moodle_mobile/data/network/apis/assignment/assignment_api.dart';
import 'package:moodle_mobile/models/comment/comment.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/common/custom_text_field.dart';
import 'package:moodle_mobile/view/common/custom_text_field_comment_detail.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:html/parser.dart' show parse;

class CommentAssignmentDetailScreen extends StatefulWidget {
  final Comment comment;
  final Function() reLoadComment;
  final UserStore userStore;
  final int assignCmdId;
  final int submissionId;
  const CommentAssignmentDetailScreen({
    Key? key,
    required this.comment,
    required this.reLoadComment,
    required this.userStore,
    required this.assignCmdId,
    required this.submissionId,
  }) : super(key: key);

  @override
  State<CommentAssignmentDetailScreen> createState() =>
      _CommentAssignmentDetailScreenState();
}

class _CommentAssignmentDetailScreenState
    extends State<CommentAssignmentDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();
  late Comment _comment;

  @override
  void initState() {
    _comment = widget.comment;
    super.initState();
  }

  regetComment() async {
    Comment tempComment =
        await readComment(widget.assignCmdId, widget.submissionId);
    setState(() {
      _comment = tempComment;
    });
  }

  Future<Comment> readComment(int assignCmdId, int submissionId) async {
    try {
      Comment tempComment = await AssignmentApi().getAssignmentComment(
          widget.userStore.user.token, assignCmdId, submissionId, 0);
      return tempComment;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
    }
    return Comment();
  }

  void _onSendPressed() async {
    if (_textEditingController.text.isEmpty) {
      return;
    }

    FocusScope.of(context).unfocus();

    var newText = _textEditingController.text;

    _textEditingController.clear();
    try {
      await AssignmentApi().sendAssignmentComment(widget.userStore.user.token,
          widget.assignCmdId, widget.submissionId, newText);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
    }

    widget.reLoadComment();
    await regetComment();

    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  String getUrlImage(String html) {
    var document = parse(html);
    var imgs = document.getElementsByTagName("img");
    if (imgs.isEmpty) {
      return "";
    } else {
      var url = imgs.first.attributes["src"];
      if (url != null) {
        url = url.replaceAll("pluginfile.php", "webservice/pluginfile.php");
        if (url.contains("?")) {
          url = url + "&token=" + widget.userStore.user.token;
        } else {
          url = url + "&token=" + widget.userStore.user.token;
        }
        return url;
      }
    }
    return "";
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    if (date1.day == date2.day &&
        date1.month == date2.month &&
        date1.year == date2.year) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: const BackButton(color: Colors.white),
        title: Text(
          AppLocalizations.of(context)!.comments,
          style: const TextStyle(color: Colors.white),
        ),
        //const Text("Messenger", style: TextStyle(color: Colors.white))
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 10,
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              controller: _scrollController,
              itemCount: _comment.comments?.length ?? 0,
              itemBuilder: (_, int index) {
                bool isSameDate = true;

                final DateTime date = DateTime.fromMillisecondsSinceEpoch(
                    (_comment.comments?[index].timecreated ?? 0) * 1000);

                // comment widget
                Widget comment = _comment.comments?[index].userid !=
                        widget.userStore.user.id
                    ? CustomCommentFieldLeft(
                        senderName: _comment.comments?[index].fullname ?? "",
                        messageText: _comment.comments?[index].content ?? "",
                        urlImage: getUrlImage(
                          _comment.comments?[index].avatar ?? "",
                        ),
                        hourMinute: DateFormat("hh:mmaa").format(date))
                    : CustomCommentFieldRight(
                        senderName: _comment.comments?[index].fullname ?? "",
                        messageText: _comment.comments?[index].content ?? "",
                        hourMinute: DateFormat("hh:mmaa").format(date),
                      );

                if (index == 0) {
                  isSameDate = false;
                } else {
                  final DateTime prevDate = DateTime.fromMillisecondsSinceEpoch(
                      (_comment.comments?[index - 1].timecreated ?? 0) * 1000);
                  isSameDate = isSameDay(date, prevDate);
                }

                if (index == 0 || isSameDate == false) {
                  return Column(children: [
                    Text(DateFormat("dd MMMM, yyyy").format(date)),
                    const SizedBox(
                      height: 5,
                    ),
                    comment
                  ]);
                } else {
                  return comment;
                }
              },
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 70, maxHeight: 150),
            child: Padding(
              padding: const EdgeInsets.all(Dimens.default_padding),
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextFieldWidget(
                      controller: _textEditingController,
                      hintText: AppLocalizations.of(context)!.enter_message,
                      borderRadius: Dimens.default_border_radius * 2,
                      maxLines: null,
                      haveLabel: false,
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: const EdgeInsets.all(8),
                      shape: const CircleBorder(),
                    ),
                    onPressed: _onSendPressed,
                    child: const Icon(Icons.send_rounded, size: 30),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}