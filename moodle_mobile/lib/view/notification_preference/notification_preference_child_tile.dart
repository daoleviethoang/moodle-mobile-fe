import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/data/network/apis/notification_preference/notification_preference_api.dart';
import 'package:moodle_mobile/models/notification_preference/notification_preference.dart';
import 'package:moodle_mobile/store/user/user_store.dart';

class NotificationPreferenceChildTile extends StatefulWidget {
  bool disable;
  Notifications components;
  String preferenceName;
  NotificationPreferenceChildTile({
    Key? key,
    required this.disable,
    required this.components,
    required this.preferenceName,
  }) : super(key: key);

  @override
  State<NotificationPreferenceChildTile> createState() =>
      _NotificationPreferenceChildTileState();
}

class _NotificationPreferenceChildTileState
    extends State<NotificationPreferenceChildTile> {
  UserStore _userStore = GetIt.instance<UserStore>();
  var online = false;
  var offline = false;

  @override
  void initState() {
    _userStore = GetIt.instance<UserStore>();
    super.initState();
  }

  setValueOfflineSwitch() async {
    widget.components.processors!
        .where((element) => element.displayname == widget.preferenceName)
        .first
        .loggedoff
        ?.checked = !offline;
    List<String> listString = widget.components.processors!
        .where((element) => element.loggedoff?.checked == true)
        .map((e) => e.name ?? "")
        .toList();
    setState(() {
      offline = !offline;
    });

    try {
      await NotificationPreferenceApi().setNotificationPreference(
          _userStore.user.token,
          (widget.components.preferencekey ?? "") + "_loggedoff",
          listString);
    } catch (e) {
      print(e.toString());
      const snackBar = SnackBar(
          content: Text(
              "Set notification preferences fail, please try again later"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  setValueOnlineSwitch() async {
    widget.components.processors!
        .where((element) => element.displayname == widget.preferenceName)
        .first
        .loggedin
        ?.checked = !online;
    List<String> listString = widget.components.processors!
        .where((element) => element.loggedin?.checked == true)
        .map((e) => e.name ?? "")
        .toList();
    try {
      await NotificationPreferenceApi().setNotificationPreference(
          _userStore.user.token,
          (widget.components.preferencekey ?? "") + "_loggedin",
          listString);
      setState(() {
        online = !online;
      });
    } catch (e) {
      print(e.toString());
      const snackBar = SnackBar(
          content: Text(
              "Set notification preferences fail, please try again later"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    var procesors = widget.components.processors!
        .where((element) => element.displayname == widget.preferenceName)
        .first;
    setState(() {
      online = procesors.loggedin?.checked ?? false;
      offline = procesors.loggedoff?.checked ?? false;
    });
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.components.displayname ?? "",
        ),
        Column(
          children: widget.disable
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
                    onChanged: (value) async {
                      await setValueOnlineSwitch();
                    },
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
                    onChanged: (value) async {
                      await setValueOfflineSwitch();
                    },
                  )
                ],
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
