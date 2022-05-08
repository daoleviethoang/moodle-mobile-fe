import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/models/notification_preference/notification_preference.dart';
import 'package:moodle_mobile/view/notification_preference/notification_preference_tile%20copy.dart';

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
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.only(left: 10, top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            components.displayname ?? "",
            textScaleFactor: 1.4,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          ListView(
            padding: EdgeInsets.only(top: 0),
            shrinkWrap: true,
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
