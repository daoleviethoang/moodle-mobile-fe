import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/dimens.dart';
import 'package:moodle_mobile/models/user_login.dart';

class UserLoginTile extends StatefulWidget {
  final UserLogin user;
  const UserLoginTile({Key? key, required this.user}) : super(key: key);

  @override
  State<UserLoginTile> createState() => _UserLoginTileState();
}

class _UserLoginTileState extends State<UserLoginTile> {
  login() {}

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {},
      child: Padding(
        padding: EdgeInsets.only(
            left: Dimens.default_padding, right: Dimens.default_padding),
        child: ListTile(
          title: Text(widget.user.baseUrl),
          subtitle: Text(widget.user.username),
        ),
      ),
    );
  }
}
