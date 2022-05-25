import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/models/message_preference/message_preference.dart';
import 'package:moodle_mobile/view/message_preference/notification_preference_child_tile.dart';

class MessagePreferenceTile extends StatelessWidget {
  String preferenceName;
  bool disable;
  Components components;
  MessagePreferenceTile(
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
          Column(
            children: components.notifications
                    ?.map(
                      (e) => MessagePreferenceChildTile(
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
