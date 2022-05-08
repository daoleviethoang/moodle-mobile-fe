import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/models/notification_preference/notification_preference.dart';

class NotificationPreferenceChildTile extends StatelessWidget {
  bool disable;
  Notifications components;
  String? preferenceName;
  NotificationPreferenceChildTile({
    Key? key,
    required this.disable,
    required this.components,
    required this.preferenceName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var procesors = components.processors!
        .where((element) => element.displayname == preferenceName)
        .first;
    var online = procesors.loggedin?.checked ?? false;
    var offline = procesors.loggedoff?.checked ?? false;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          components.displayname ?? "",
        ),
        ListView(
          padding: EdgeInsets.only(top: 0),
          shrinkWrap: true,
          children: disable
              ? [
                  MergeSemantics(
                    child: ListTileTheme.merge(
                      child: ListTile(
                        title: Row(children: [
                          Text("Online"),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(Icons.help, color: Colors.blue),
                        ]),
                        trailing: Text("Vô hiệu hoá"),
                      ),
                    ),
                  ),
                  MergeSemantics(
                    child: ListTileTheme.merge(
                      child: ListTile(
                        title: Row(children: [
                          Text("Offline"),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(Icons.help, color: Colors.blue),
                        ]),
                        trailing: Text("Vô hiệu hoá"),
                      ),
                    ),
                  )
                ]
              : [
                  SwitchListTile(
                    title: Row(children: [
                      Text("Online"),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(Icons.help, color: Colors.blue),
                    ]),
                    value: online,
                    onChanged: (value) async {},
                  ),
                  SwitchListTile(
                    title: Row(children: [
                      Text("Offline"),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(Icons.help, color: Colors.blue),
                    ]),
                    value: offline,
                    onChanged: (value) async {},
                  )
                ],
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
    ;
  }
}
