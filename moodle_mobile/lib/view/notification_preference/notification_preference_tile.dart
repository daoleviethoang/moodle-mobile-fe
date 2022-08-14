import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/models/notification_preference/notification_preference.dart';
import 'package:moodle_mobile/view/notification_preference/notification_preference_child_tile.dart';

class NotificationPreferenceTile extends StatelessWidget {
  String preferenceName;
  bool disable;
  Components components;
  NotificationPreferenceTile(
      {Key? key,
      required this.preferenceName,
      required this.disable,
      required this.components})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: MoodleColors.grey_soft),
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.only(left: 10, top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            components.displayname ?? "",
            textScaleFactor: 1.4,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Column(
            children: components.notifications
                    ?.map(
                      (e) => NotificationPreferenceChildTile(
                        disable: disable,
                        components: e,
                        preferenceName: preferenceName,
                      ),
                    )
                    .toList() ??
                [],
          ),
        ],
      ),
    );
  }
}