import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/constants/styles.dart';
import 'package:moodle_mobile/view/assignment/index.dart';
import 'package:moodle_mobile/view/common/menu_item.dart' as m;
import 'package:moodle_mobile/view/quiz/index.dart';
import 'package:moodle_mobile/view/viewer/image_viewer.dart';
import 'package:moodle_mobile/view/viewer/video_viewer.dart';
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
    return m.MenuItem(
      icon: const Icon(Icons.forum_outlined),
      color: Colors.amber,
      title: title,
      fullWidth: true,
      onPressed: onPressed,
    );
  }
}

class ChatItem extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;

  const ChatItem({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return m.MenuItem(
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
    return m.MenuItem(
      icon: const Icon(CupertinoIcons.book),
      color: Colors.pink,
      title: title,
      fullWidth: true,
      onPressed: () async {
        // Download this document from link
        final uri = Uri.parse(documentUrl);
        var ableLaunch = await canLaunchUrl(uri);
        if (ableLaunch) {
          await launchUrl(uri);
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
    return m.MenuItem(
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
    return m.MenuItem(
      icon: const Icon(CupertinoIcons.link),
      color: Colors.deepPurple,
      title: title,
      subtitle: url,
      fullWidth: true,
      onPressed: () async {
        // Go to webpage in browser
        final uri = Uri.parse(url);
        var ableLaunch = await canLaunchUrl(uri);
        if (ableLaunch) {
          await launchUrl(uri);
        } else {
          print("URL can't be launched.");
        }
      },
    );
  }
}

class SubmissionItem extends StatelessWidget {
  final String title;
  final int submissionId;
  final DateTime? dueDate;
  final int courseId;

  const SubmissionItem({
    Key? key,
    required this.title,
    required this.submissionId,
    this.dueDate,
    required this.courseId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return m.MenuItem(
      icon: const Icon(CupertinoIcons.doc),
      color: MoodleColors.blue,
      title: title,
      subtitle: (dueDate == null)
          ? null
          : DateFormat('HH:mm, dd MMMM, yyyy').format(dueDate!),
      fullWidth: true,
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AssignmentScreen(
                      title: title,
                      assignInstanceId: submissionId,
                      courseId: courseId,
                    )));
      },
    );
  }
}

class QuizItem extends StatelessWidget {
  final String title;
  final int courseId;
  final int quizInstanceId;
  final DateTime? openDate;

  const QuizItem({
    Key? key,
    required this.title,
    required this.quizInstanceId,
    required this.courseId,
    this.openDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return m.MenuItem(
      icon: const Icon(CupertinoIcons.question_square),
      color: MoodleColors.blue,
      title: title,
      subtitle: (openDate == null)
          ? null
          : DateFormat('HH:mm, dd MMMM, yyyy').format(openDate!),
      fullWidth: true,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizScreen(
              title: title,
              quizInstanceId: quizInstanceId,
              courseId: courseId,
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
    return m.MenuItem(
      icon: const Icon(CupertinoIcons.doc),
      color: Colors.grey,
      title: title,
      onPressed: () {
        // TODO: Download this document from link
      },
    );
  }
}

class PageItem extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;

  const PageItem({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return m.MenuItem(
      icon: const Icon(CupertinoIcons.doc_richtext),
      color: Colors.pink,
      title: title,
      fullWidth: true,
      onPressed: onPressed,
    );
  }
}

class FolderItem extends StatelessWidget {
  final String title;
  final int instanceId;

  const FolderItem({
    Key? key,
    required this.title,
    required this.instanceId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return m.MenuItem(
      icon: const Icon(CupertinoIcons.folder),
      color: Colors.grey,
      title: title,
      onPressed: () {
        // TODO: Open folder in a new screen
      },
    );
  }
}

class ZoomItem extends StatelessWidget {
  final String title;
  final int instanceId;

  const ZoomItem({
    Key? key,
    required this.title,
    required this.instanceId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return m.MenuItem(
      image: const CircleImageView(
        imageUrl: 'https://st1.zoom.us/static/6.1.6366/image/new/home/meetings.png',
        placeholder: Icon(CupertinoIcons.video_camera, size: 48),
      ),
      color: Colors.grey,
      title: title,
      onPressed: () {
        // TODO: Open zoom
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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Html(
        data: text,
        style: MoodleStyles.htmlStyle,
        onImageTap: (url, cxt, attributes, element) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => ImageViewer(
                title: 'Image',
                base64: url?.split(',')[1] ?? '',
              )));
        },
        onLinkTap: (url, cxt, attributes, element) async {
          await showGeneralDialog(
            context: context,
            pageBuilder: (context, ani1, ani2) {
              return AlertDialog(
                title: const Text('Open link in browser'),
                content: Text(url ?? ''),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16))),
                actions: [
                  TextButton(
                    onPressed: () async => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await launchUrl(Uri.parse(url ?? ''));
                    },
                    child: const Text('Open'),
                  ),
                ],
              );
            },
          );
        },
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
          color: Theme.of(context).colorScheme.primary,
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
                      duration: const Duration(milliseconds: 200),
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