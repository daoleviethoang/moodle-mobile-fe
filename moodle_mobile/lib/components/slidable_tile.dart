import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/constants/dimens.dart';

class SlidableTile extends StatelessWidget {
  const SlidableTile(
      {Key? key,
      required this.isNotification,
      required this.nameInfo,
      required this.messContent,
      required this.onDeletePress,
      required this.onAlarmPress,
      required this.onMessDetailPress})
      : super(key: key);

  final bool isNotification;
  final String nameInfo;
  final String messContent;
  final VoidCallback onDeletePress;
  final VoidCallback onAlarmPress;
  final VoidCallback onMessDetailPress;
  @override
  Widget build(BuildContext context) {
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
        title: Text(
          nameInfo,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          messContent,
          style: TextStyle(fontSize: 12, color: MoodleColors.gray),
        ),
        trailing: Icon(isNotification ? null : Icons.notifications_off),
      ),
    );
  }
}
