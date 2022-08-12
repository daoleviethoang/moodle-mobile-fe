import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/dimens.dart';
import 'package:moodle_mobile/data/network/apis/assignment/assignment_api.dart';
import 'package:moodle_mobile/models/comment/comment.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/common/custom_text_field.dart';
import 'package:moodle_mobile/view/common/custom_text_field_comment_detail.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;

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

  void _onSendPressed() async {
    if (_textEditingController.text.isEmpty) {
      return;
    }

    var newText = _textEditingController.text;

    _textEditingController.clear();
    try {
      await AssignmentApi().sendAssignmentComment(widget.userStore.user.token,
          widget.assignCmdId, widget.submissionId, newText);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
    }

    await widget.reLoadComment();

    _scrollController.animateTo(
      0,
      duration: const Duration(seconds: 2),
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
              reverse: true,
              controller: _scrollController,
              itemCount: widget.comment.comments?.length ?? 0,
              itemBuilder: (_, int index) {
                return widget.comment.comments?[index].userid !=
                        widget.userStore.user.id
                    ? CustomCommentFieldLeft(
                        senderName:
                            widget.comment.comments?[index].fullname ?? "",
                        messageText:
                            widget.comment.comments?[index].content ?? "",
                        urlImage: getUrlImage(
                          widget.comment.comments?[index].avatar ?? "",
                        ),
                      )
                    : CustomCommentFieldRight(
                        senderName:
                            widget.comment.comments?[index].fullname ?? "",
                        messageText:
                            widget.comment.comments?[index].content ?? "",
                        urlImage: getUrlImage(
                          widget.comment.comments?[index].avatar ?? "",
                        ),
                      );
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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimens.default_padding),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: const EdgeInsets.all(8),
                        shape: const CircleBorder(),
                      ),
                      onPressed: () {},
                      child: const Icon(Icons.image_rounded, size: 30),
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
