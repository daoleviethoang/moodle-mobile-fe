import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/constants/dimens.dart';
import 'package:moodle_mobile/models/user_login.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/direct_page.dart';

class UserLoginTile extends StatefulWidget {
  final UserLogin user;
  final UserStore userStore;
  const UserLoginTile({Key? key, required this.user, required this.userStore})
      : super(key: key);

  @override
  State<UserLoginTile> createState() => _UserLoginTileState();
}

class _UserLoginTileState extends State<UserLoginTile> {
  login() async {
    widget.userStore.setBaseUrl(widget.user.baseUrl);

    await widget.userStore.setUser(
      widget.user.token,
      widget.user.username,
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const DirectScreen();
        },
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: Dimens.default_padding,
          right: Dimens.default_padding,
          bottom: 20),
      child: ListTile(
        onTap: () async {
          await login();
        },
        tileColor: MoodleColors.grey_soft,
        leading: const CircleAvatar(
          radius: 20,
          backgroundColor: MoodleColors.blue,
          child: Icon(
            Icons.person,
            size: 20,
            color: Colors.white,
          ),
        ),
        title: Text(
          widget.user.baseUrl,
          maxLines: 1,
          overflow: TextOverflow.clip,
        ),
        subtitle: Text(widget.user.username),
      ),
    );
  }
}
