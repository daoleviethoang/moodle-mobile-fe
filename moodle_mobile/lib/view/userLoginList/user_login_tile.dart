import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/constants/dimens.dart';
import 'package:moodle_mobile/models/user_login.dart';
import 'package:moodle_mobile/sqllite/sql.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/common/image_view.dart';
import 'package:moodle_mobile/view/direct_page.dart';

class UserLoginTile extends StatefulWidget {
  final UserLogin user;
  final UserStore userStore;
  final VoidCallback refresh;
  const UserLoginTile(
      {Key? key,
      required this.user,
      required this.userStore,
      required this.refresh})
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
    return InkWell(
        onTap: () async {
          await login();
        },
        child: Padding(
            padding: const EdgeInsets.only(
                left: Dimens.default_padding,
                right: Dimens.default_padding,
                bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(1000),
                        child: widget.user.photo != null
                            ? Image.network(
                                widget.user.photo! +
                                    "&token=" +
                                    widget.user.token,
                                scale: 1.4,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      height: 70,
                                      width: 70,
                                      decoration: const BoxDecoration(
                                          color: MoodleColors.blue),
                                      child: const Icon(
                                        Icons.person,
                                        size: 45,
                                        color: Colors.white,
                                      ),
                                    ))
                            : Container(
                                height: 70,
                                width: 70,
                                decoration: const BoxDecoration(
                                    color: MoodleColors.blue),
                                child: const Icon(
                                  Icons.person,
                                  size: 45,
                                  color: Colors.white,
                                ),
                              )),
                    SizedBox(width: 15),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.user.username,
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textScaleFactor: 1.5,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            widget.user.baseUrl.replaceAll("https://", ""),
                            textScaleFactor: 1.1,
                          ),
                        ]),
                  ],
                ),
                IconButton(
                    onPressed: () async {
                      await SQLHelper.deleteUserItem(
                          widget.user.baseUrl, widget.user.username);
                      widget.refresh();
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.black87,
                      size: 35,
                    )),
              ],
            )));
  }
}
