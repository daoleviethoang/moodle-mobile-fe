import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/constants/dimens.dart';
import 'package:moodle_mobile/constants/styles.dart';
import 'package:moodle_mobile/models/conversation/conversation_message.dart';
import 'package:flutter_html/flutter_html.dart';

class SlidableTile extends StatelessWidget {
  const SlidableTile(
      {Key? key,
      this.isNotification = true,
      this.isStarred = false,
      required this.nameInfo,
      required this.message,
      required this.onDeletePress,
      required this.onAlarmPress,
      required this.onMessDetailPress})
      : super(key: key);

  final bool isNotification;
  final bool isStarred;
  final String nameInfo;
  final ConversationMessageModel? message;
  final VoidCallback? onDeletePress;
  final VoidCallback? onAlarmPress;
  final VoidCallback? onMessDetailPress;

  @override
  Widget build(BuildContext context) {
    String messageContent = "";
    String timeCreated = DateTime.now().toString();

    if (message != null) {
      messageContent = HtmlParser.parseHTML(message!.text).text;
      timeCreated = DateFormat('dd-MM-yyyy').format(
          DateTime.fromMillisecondsSinceEpoch(message!.timeCreated * 1000));
    }
    return Slidable(
      key: ValueKey(nameInfo),
      groupTag: '0',
      endActionPane:
          ActionPane(extentRatio: 0.3, motion: const ScrollMotion(), children: [
        Material(
          color: MoodleColors.gray,
          shape: const RoundedRectangleBorder(),
          child: InkWell(
            child: const SizedBox(
                width: 56,
                height: 76,
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                )),
            onTap: onDeletePress,
          ),
        ),
        Material(
          color: MoodleColors.purple,
          shape: const RoundedRectangleBorder(),
          child: InkWell(
            child: SizedBox(
                width: 56,
                height: 76,
                child: Icon(
                  isNotification
                      ? Icons.notifications
                      : Icons.notifications_off,
                  color: Colors.white,
                )),
            onTap: onAlarmPress,
          ),
        ),
      ]),
      child: ListTile(
        onTap: onMessDetailPress,
        leading: const CircleAvatar(
          radius: 28.5,
          backgroundColor: MoodleColors.blue,
          child: Icon(
            Icons.person,
            size: Dimens.default_size_icon,
            color: Colors.white,
          ),
        ),
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 2),
              child: Text(
                nameInfo,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
            if (isStarred)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 2),
                child: Icon(Icons.star_rounded, color: Colors.amber, size: 16),
              ),
            if (isNotification)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 2),
                child: Icon(Icons.notifications_off, size: 16),
              )
          ],
        ),
        subtitle: message != null
            ? AutoSizeText(
                '$messageContent  ·  $timeCreated',
                maxLines: 1,
                style: MoodleStyles.messageContentStyle,
                overflowReplacement: Row(
                  children: [
                    Expanded(
                      child: Text(
                        messageContent,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: MoodleStyles.messageContentStyle,
                      ),
                    ),
                    Text('  ·  $timeCreated',
                        style: MoodleStyles.messageContentStyle),
                  ],
                ),
              )
            : const Text(''),
      ),
    );
  }
}
