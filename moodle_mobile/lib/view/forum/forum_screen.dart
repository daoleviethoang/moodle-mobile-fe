import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'forum_discussion_screen.dart';

class ForumScreen extends StatefulWidget {
  final int? forumId;
  final int? courseId;
  final String? forumName;

  const ForumScreen({
    Key? key,
    this.forumId,
    this.courseId,
    this.forumName,
  }) : super(key: key);

  @override
  _ForumScreenState createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  late int? _forumId;
  late int? _courseId;
  late String? _forumName;

  @override
  void initState() {
    super.initState();

    _forumId = widget.forumId;
    _courseId = widget.courseId;
    _forumName = widget.forumName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_forumName ?? AppLocalizations.of(context)!.discussion),
        leading: TextButton(
          style: TextButton.styleFrom(
            primary: Colors.white,
            padding: EdgeInsets.zero,
            shape: const CircleBorder(),
          ),
          child: const Icon(CupertinoIcons.back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        child: ForumDiscussionScreen(
          courseId: _courseId,
          forumId: _forumId,
        ),
      ),
    );
  }
}