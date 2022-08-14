import 'package:alpha_quiz/alpha_quiz.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:html/parser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/constants/dimens.dart';
import 'package:moodle_mobile/constants/styles.dart';
import 'package:moodle_mobile/data/network/apis/calendar/calendar_service.dart';
import 'package:moodle_mobile/models/calendar/event.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/assignment/index.dart';
import 'package:moodle_mobile/view/common/menu_item.dart' as m;
import 'package:moodle_mobile/view/quiz/index.dart';
import 'package:moodle_mobile/view/viewer/image_viewer.dart';
import 'package:moodle_mobile/view/viewer/video_viewer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'custom_button.dart';
import 'image_view.dart';

class _ModuleWrapper extends StatefulWidget {
  final bool? completed;
  final Function(bool?)? onCompletionChange;
  final Widget child;

  const _ModuleWrapper({
    Key? key,
    this.completed,
    this.onCompletionChange,
    required this.child,
  }) : super(key: key);

  @override
  State<_ModuleWrapper> createState() => _ModuleWrapperState();
}

class _ModuleWrapperState extends State<_ModuleWrapper> {
  bool? _completed;

  @override
  void initState() {
    super.initState();
    _completed = widget.completed;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.child,
        if (widget.completed != null)
          Padding(
            padding: const EdgeInsets.only(left: 32),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: _completed! ? MoodleColors.blue : Colors.white,
              ),
              onPressed: widget.onCompletionChange == null
                  ? () {}
                  : () async {
                      final c = await widget.onCompletionChange!(_completed);
                      setState(() => _completed = c);
                    },
              child: Text("Mark done",
                  style: TextStyle(
                    color: _completed! ? Colors.white : MoodleColors.blue,
                  )),
            ),
          ),
      ],
    );
  }
}

class ModuleItem extends StatelessWidget {
  final bool? completed;
  final Function(bool?)? onCompletionChange;

  final Widget? icon;
  final Widget? image;
  final Color? color;
  final String title;
  final String? subtitle;
  final bool? fullWidth;
  final VoidCallback? onPressed;

  const ModuleItem({
    Key? key,
    this.completed,
    this.onCompletionChange,
    this.icon,
    this.image,
    this.color,
    required this.title,
    this.subtitle,
    this.fullWidth,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _ModuleWrapper(
      completed: completed,
      onCompletionChange: onCompletionChange,
      child: m.MenuItem(
        icon: icon,
        image: image,
        color: color,
        title: title,
        subtitle: subtitle,
        fullWidth: fullWidth,
        onPressed: onPressed,
      ),
    );
  }
}

// region Icon and text

class ForumItem extends StatelessWidget {
  final bool? completed;
  final Function(bool?)? onCompletionChange;

  final String title;
  final VoidCallback? onPressed;

  const ForumItem({
    Key? key,
    this.completed,
    this.onCompletionChange,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ModuleItem(
      completed: completed,
      onCompletionChange: onCompletionChange,
      icon: const Icon(Icons.forum_outlined),
      color: Colors.amber,
      title: title,
      fullWidth: true,
      onPressed: onPressed,
    );
  }
}

class ChatItem extends StatelessWidget {
  final bool? completed;
  final Function(bool?)? onCompletionChange;

  final String title;
  final VoidCallback? onPressed;

  const ChatItem({
    Key? key,
    this.completed,
    this.onCompletionChange,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ModuleItem(
      completed: completed,
      onCompletionChange: onCompletionChange,
      icon: const Icon(CupertinoIcons.chat_bubble_2),
      color: Colors.amber,
      title: title,
      fullWidth: true,
      onPressed: onPressed,
    );
  }
}

class DocumentItem extends StatelessWidget {
  final bool? completed;
  final Function(bool?)? onCompletionChange;

  final String title;
  final String documentUrl;

  const DocumentItem({
    Key? key,
    this.completed,
    this.onCompletionChange,
    required this.title,
    required this.documentUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ModuleItem(
      completed: completed,
      onCompletionChange: onCompletionChange,
      icon: const Icon(CupertinoIcons.book),
      color: Colors.pink,
      title: title,
      fullWidth: true,
      onPressed: () async {
        // Download this document from link
        final uri = Uri.parse(documentUrl);
        var ableLaunch = await canLaunchUrl(uri);
        if (ableLaunch) {
          await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
        } else {
          if (kDebugMode) {
            print("URL can't be launched.");
          }
        }
      },
    );
  }
}

class VideoItem extends StatelessWidget {
  final bool? completed;
  final Function(bool?)? onCompletionChange;

  final String title;
  final String videoUrl;

  const VideoItem({
    Key? key,
    this.completed,
    this.onCompletionChange,
    required this.title,
    required this.videoUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ModuleItem(
      completed: completed,
      onCompletionChange: onCompletionChange,
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
  final bool? completed;
  final Function(bool?)? onCompletionChange;

  final String title;
  final String url;
  final int? id;

  const UrlItem({
    Key? key,
    this.completed,
    this.onCompletionChange,
    required this.title,
    required this.url,
    this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ModuleItem(
      completed: completed,
      onCompletionChange: onCompletionChange,
      icon: const Icon(CupertinoIcons.link),
      color: Colors.deepPurple,
      title: title,
      subtitle: url,
      fullWidth: true,
      onPressed: () async {
        if (id != null && AlphaAPI.isAlphaModule(url)) {
          final user = GetIt.instance<UserStore>();
          AlphaQuizData.setWSToken(user.user.token);
          AlphaQuizData.setUsername(user.user.username);
          AlphaAPI.moodleBaseUrl = user.user.baseUrl;

          Navigator.of(context).push(CupertinoPageRoute(builder: (_) {
            return PlayScreen(toolId: id!);
          }));

          return;
        }

        // Go to webpage in browser
        final uri = Uri.parse(url);
        var ableLaunch = await canLaunchUrl(uri);
        if (ableLaunch) {
          await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
        } else {
          if (kDebugMode) {
            print("URL can't be launched.");
          }
        }
      },
    );
  }
}

class SubmissionItem extends StatelessWidget {
  final bool? completed;
  final Function(bool?)? onCompletionChange;

  final String title;
  final int submissionId;
  final bool? isTeacher;
  final DateTime? dueDate;
  final int courseId;

  const SubmissionItem({
    Key? key,
    this.completed,
    this.onCompletionChange,
    required this.title,
    required this.submissionId,
    this.dueDate,
    required this.courseId,
    required this.isTeacher,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dueString = DateFormat(
      'HH:mm, dd MMMM, yyyy',
      Localizations.localeOf(context).languageCode,
    ).format(dueDate ?? DateTime.now());
    return ModuleItem(
      completed: completed,
      onCompletionChange: onCompletionChange,
      icon: const Icon(CupertinoIcons.doc),
      color: MoodleColors.blue,
      title: title,
      subtitle: (dueDate == null) ? null : dueString,
      fullWidth: true,
      onPressed: () {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => AssignmentScreen(
                      title: title,
                      assignInstanceId: submissionId,
                      courseId: courseId,
                      isTeacher: isTeacher,
                    )));
      },
    );
  }
}

class QuizItem extends StatelessWidget {
  final bool? completed;
  final Function(bool?)? onCompletionChange;

  final String title;
  final int courseId;
  final int quizInstanceId;
  final bool? isTeacher;
  final DateTime? openDate;

  const QuizItem({
    Key? key,
    this.completed,
    this.onCompletionChange,
    required this.title,
    required this.isTeacher,
    required this.quizInstanceId,
    required this.courseId,
    this.openDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dueString = DateFormat(
      'HH:mm, dd MMMM, yyyy',
      Localizations.localeOf(context).languageCode,
    ).format(openDate ?? DateTime.now());
    return ModuleItem(
      completed: completed,
      onCompletionChange: onCompletionChange,
      icon: const Icon(CupertinoIcons.question_square),
      color: MoodleColors.blue,
      title: title,
      subtitle: (openDate == null) ? null : dueString,
      fullWidth: true,
      onPressed: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => QuizScreen(
              title: title,
              quizInstanceId: quizInstanceId,
              courseId: courseId,
              isTeacher: isTeacher,
            ),
          ),
        );
      },
    );
  }
}

class AttachmentItem extends StatelessWidget {
  final bool? completed;
  final Function(bool?)? onCompletionChange;

  final String? title;
  final String? attachmentUrl;

  const AttachmentItem({
    Key? key,
    this.completed,
    this.onCompletionChange,
    this.title,
    this.attachmentUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return attachmentUrl == null
        ? Container()
        : ModuleItem(
            completed: completed,
            onCompletionChange: onCompletionChange,
            icon: const Icon(CupertinoIcons.doc),
            color: Colors.grey,
            title: title!,
            onPressed: () {
              // TODO: Download this document from link
            },
          );
  }
}

class PageItem extends StatelessWidget {
  final bool? completed;
  final Function(bool?)? onCompletionChange;

  final String title;
  final VoidCallback? onPressed;

  const PageItem({
    Key? key,
    this.completed,
    this.onCompletionChange,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ModuleItem(
      completed: completed,
      onCompletionChange: onCompletionChange,
      icon: const Icon(CupertinoIcons.doc_richtext),
      color: Colors.pink,
      title: title,
      fullWidth: true,
      onPressed: onPressed,
    );
  }
}

class FolderItem extends StatelessWidget {
  final bool? completed;
  final Function(bool?)? onCompletionChange;

  final String title;
  final int instanceId;

  const FolderItem({
    Key? key,
    this.completed,
    this.onCompletionChange,
    required this.title,
    required this.instanceId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ModuleItem(
      completed: completed,
      onCompletionChange: onCompletionChange,
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
  final bool? completed;
  final Function(bool?)? onCompletionChange;

  final String title;
  final int instanceId;

  const ZoomItem({
    Key? key,
    this.completed,
    this.onCompletionChange,
    required this.title,
    required this.instanceId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ModuleItem(
      completed: completed,
      onCompletionChange: onCompletionChange,
      image: const CircleImageView(
        imageUrl:
            'https://st1.zoom.us/static/6.1.6366/image/new/home/meetings.png',
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

class EventItem extends StatefulWidget {
  final bool? completed;
  final Function(bool?)? onCompletionChange;

  final String title;
  final DateTime date;
  final String token;
  final Event event;

  const EventItem({
    Key? key,
    this.completed,
    this.onCompletionChange,
    required this.title,
    required this.date,
    required this.token,
    required this.event,
  }) : super(key: key);

  @override
  State<EventItem> createState() => _EventItemState();
}

class _EventItemState extends State<EventItem> {
  bool _hiding = false;

  String getDueString(BuildContext context) => DateFormat(
        'HH:mm, dd MMMM, yyyy',
        Localizations.localeOf(context).languageCode,
      ).format(widget.date);

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _hiding ? 0 : 1,
      alignment: Alignment.topCenter,
      duration: const Duration(milliseconds: 300),
      onEnd: () {
        if (_hiding) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(AppLocalizations.of(context)!.event_deleted)),
          );
        }
      },
      child: ModuleItem(
        completed: widget.completed,
        onCompletionChange: widget.onCompletionChange,
        icon: const Icon(CupertinoIcons.calendar),
        color: MoodleColors.blue,
        title: widget.title,
        subtitle: getDueString(context),
        fullWidth: true,
        onPressed: () => _onPressed(context),
      ),
    );
  }

  void _onPressed(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (builder) => SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      widget.title,
                      textAlign: TextAlign.left,
                      softWrap: true,
                      style: MoodleStyles.bottomSheetTitleStyle,
                    ),
                  ),
                  Container(height: 20),
                  Text(
                    '${AppLocalizations.of(context)!.due} '
                    '${getDueString(context)}',
                    style: MoodleStyles.noteTimestampStyle,
                  ),
                  Container(height: 10),
                  if ((widget.event.description ?? '').isNotEmpty)
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height * 0.25,
                        minWidth: MediaQuery.of(context).size.width,
                        maxWidth: MediaQuery.of(context).size.width,
                      ),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: CupertinoColors.tertiarySystemFill,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            widget.event.description!,
                            textAlign: TextAlign.left,
                            softWrap: true,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  Container(height: 20),
                  CustomButtonWidget(
                    onPressed: () async {
                      await _onDeletePressed(context);
                    },
                    textButton: AppLocalizations.of(context)!.mark_done_delete,
                    useWarningColor: true,
                    filled: false,
                  ),
                ],
              ),
            ),
            Container(height: Dimens.default_padding_double),
            Container(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  Future<void> _onDeletePressed(BuildContext context) async {
    Navigator.of(context).pop();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.mark_done_delete),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context)!.mark_done_delete_confirm),
              Container(height: 10),
              Text(
                widget.title,
                textAlign: TextAlign.left,
                softWrap: true,
                style: const TextStyle(fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Container(height: 10),
              Text(
                widget.event.description!,
                textAlign: TextAlign.left,
                softWrap: true,
                maxLines: 5,
                overflow: TextOverflow.fade,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(AppLocalizations.of(context)!.cancel),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(
                AppLocalizations.of(context)!.delete,
                style: TextStyle(color: Theme.of(context).errorColor),
              ),
              onPressed: () async {
                final result = await CalendarService()
                    .deleteEvent(widget.token, widget.event.id!);
                if (result) setState(() => _hiding = true);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

// endregion

// region Cards

class LabelItem extends StatelessWidget {
  final bool? completed;
  final Function(bool?)? onCompletionChange;

  final String? text;
  final Map<String, Style>? style;
  final Map<bool Function(RenderContext), CustomRender>? customData;
  final bool hasPadding;

  const LabelItem({
    Key? key,
    this.completed,
    this.onCompletionChange,
    required this.text,
    this.style,
    this.customData,
    this.hasPadding = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _ModuleWrapper(
      completed: completed,
      onCompletionChange: onCompletionChange,
      child: RichTextCard(
        text: text,
        style: style,
        customData: customData,
        hasPadding: hasPadding,
      ),
    );
  }
}

class RichTextCard extends StatelessWidget {
  final String? text;
  final Map<String, Style>? style;
  final Map<bool Function(RenderContext), CustomRender>? customData;
  final bool hasPadding;

  const RichTextCard({
    Key? key,
    required this.text,
    this.style,
    this.customData,
    this.hasPadding = true,
  }) : super(key: key);

  String get _textFormatted {
    var txt = text ?? '';
    txt = txt.replaceAll(RegExp(r'<br/?>'), '<div/>');
    return txt;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: hasPadding ? Dimens.default_padding : 0),
      child: Html(
        data: _textFormatted,
        style: style ?? MoodleStyles.htmlStyle,
        onImageTap: (url, cxt, attributes, element) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => ImageViewer(
                    title: AppLocalizations.of(context)!.image,
                    url: url != null && !url.contains(',') ? url : '',
                    base64: (url ?? '').contains(',') ? url!.split(',')[1] : '',
                  )));
        },
        customRenders: customData ?? {},
        onLinkTap: (url, cxt, attributes, element) async {
          await showGeneralDialog(
            context: context,
            pageBuilder: (context, ani1, ani2) {
              return AlertDialog(
                title: Text(AppLocalizations.of(context)!.open_link),
                content: Text(url ?? ''),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16))),
                actions: [
                  TextButton(
                    onPressed: () async => Navigator.pop(context),
                    child: Text(AppLocalizations.of(context)!.cancel),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await launchUrl(
                        Uri.parse(url ?? ''),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    child: Text(AppLocalizations.of(context)!.open),
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
  final String? text;

  const HeaderItem({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final text = parseFragment(this.text ?? '').text ?? '';
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        softWrap: true,
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
  /// The title of the section, will be hidden if is null or is container
  final Widget? header;

  /// A list of item contained in the section
  final List<Widget>? body;

  /// Whether a separator is displayed between sections
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
        if (widget.header != null && widget.header is! Container) ...[
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: widget.header,
                  ),
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
        if (widget.hasSeparator) const LineItem(),
      ],
    );
  }
}

// endregion