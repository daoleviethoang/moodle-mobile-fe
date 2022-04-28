import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:moodle_mobile/constants/styles.dart';
import 'package:moodle_mobile/view/assignment/index.dart';
import 'package:moodle_mobile/view/common/menu_item.dart';
import 'package:moodle_mobile/view/quiz/index.dart';
import 'package:moodle_mobile/view/video_viewer.dart';
import 'package:url_launcher/url_launcher.dart';

// region Icon and text

class ForumItem extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;

  const ForumItem({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MenuItem(
      icon: const Icon(CupertinoIcons.chat_bubble_2),
      color: Colors.amber,
      title: title,
      fullWidth: true,
      onPressed: onPressed,
    );
  }
}

class DocumentItem extends StatelessWidget {
  final String title;
  final String documentUrl;

  const DocumentItem({
    Key? key,
    required this.title,
    required this.documentUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MenuItem(
      icon: const Icon(CupertinoIcons.book),
      color: Colors.pink,
      title: title,
      fullWidth: true,
      onPressed: () async {
        // Download this document from link
        var ableLaunch = await canLaunch(documentUrl);
        if (ableLaunch) {
          await launch(documentUrl);
        } else {
          print("URL can't be launched.");
        }
      },
    );
  }
}

class VideoItem extends StatelessWidget {
  final String title;
  final String videoUrl;

  const VideoItem({
    Key? key,
    required this.title,
    required this.videoUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MenuItem(
      icon: const Icon(CupertinoIcons.video_camera),
      color: Colors.green,
      title: title,
      fullWidth: true,
      onPressed: () {
        // Watch this video in a fullscreen view
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => VideoViewer(
                  title: title,
                  url: videoUrl,
                )));
      },
    );
  }
}

class UrlItem extends StatelessWidget {
  final String title;
  final String url;

  const UrlItem({
    Key? key,
    required this.title,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MenuItem(
      icon: const Icon(CupertinoIcons.link),
      color: Colors.deepPurple,
      title: title,
      subtitle: url,
      fullWidth: true,
      onPressed: () async {
        // Go to webpage in browser
        var ableLaunch = await canLaunch(url);
        if (ableLaunch) {
          await launch(url);
        } else {
          print("URL can't be launched.");
        }
      },
    );
  }
}

class SubmissionItem extends StatelessWidget {
  final String title;
  final String submissionId;
  final DateTime? dueDate;

  const SubmissionItem({
    Key? key,
    required this.title,
    required this.submissionId,
    this.dueDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MenuItem(
      icon: const Icon(CupertinoIcons.doc),
      color: Colors.blue,
      title: title,
      subtitle: (dueDate == null)
          ? null
          : DateFormat('dd MMMM, yyyy').format(dueDate!),
      fullWidth: true,
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AssignmentScreen(
                      title: title,
                      assignInstanceId: 11129,
                      courseId: 1873,
                    )));
      },
    );
  }
}

class QuizItem extends StatelessWidget {
  final String title;
  final String quizId;
  final DateTime? openDate;

  const QuizItem({
    Key? key,
    required this.title,
    required this.quizId,
    this.openDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MenuItem(
      icon: const Icon(CupertinoIcons.question_square),
      color: Colors.blue,
      title: title,
      subtitle: (openDate == null)
          ? null
          : DateFormat('dd MMMM, yyyy').format(openDate!),
      fullWidth: true,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizScreen(
              title: title,
              quizInstanceId: 458,
              courseId: 1250,
            ),
          ),
        );
      },
    );
  }
}

class AttachmentItem extends StatelessWidget {
  final String title;
  final String attachmentUrl;

  const AttachmentItem({
    Key? key,
    required this.title,
    required this.attachmentUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MenuItem(
      icon: const Icon(CupertinoIcons.doc),
      color: Colors.grey,
      title: title,
      onPressed: () {
        // TODO: Download this document from link
      },
    );
  }
}

// endregion

// region Cards

class RichTextCard extends StatelessWidget {
  final String text;

  const RichTextCard({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Html(
            data: text,
            style: MoodleStyles.htmlStyle,
          ),
        ),
      ),
    );
  }
}

// endregion

// region Text and others

class HeaderItem extends StatelessWidget {
  final String text;

  const HeaderItem({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class LineItem extends StatelessWidget {
  final double width;

  const LineItem({Key? key, this.width = 1.5}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Container(
        color: Theme.of(context).hintColor.withOpacity(.25),
        width: double.infinity,
        height: width,
      ),
    );
  }
}

// endregion

// region Section

class SectionItem extends StatefulWidget {
  final Widget? header;
  final List<Widget>? body;
  final bool hasSeparator;

  const SectionItem({
    Key? key,
    required this.header,
    this.body,
    this.hasSeparator = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SectionItemState();
}

class _SectionItemState extends State<SectionItem> {
  var _expanded = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.header != null) ...[
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: widget.header,
                ),
                SizedBox(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      primary: Theme.of(context).colorScheme.onSurface,
                      padding: EdgeInsets.zero,
                      shape: const CircleBorder(),
                      fixedSize: const Size.fromHeight(16),
                    ),
                    child: AnimatedRotation(
                      turns: _expanded ? 0 : .5,
                      duration: const Duration(milliseconds: 400),
                      child: const Icon(CupertinoIcons.chevron_down),
                    ),
                    onPressed: () => setState(() => _expanded = !_expanded),
                  ),
                ),
              ],
            ),
          )
        ],
        AnimatedSize(
          curve: Curves.easeInOut,
          alignment: Alignment.centerLeft,
          duration: const Duration(milliseconds: 400),
          child: Column(
            children: [...(_expanded ? (widget.body ?? []) : [])],
          ),
        ),
        widget.hasSeparator ? const LineItem() : Container(),
      ],
    );
  }
}

// endregion