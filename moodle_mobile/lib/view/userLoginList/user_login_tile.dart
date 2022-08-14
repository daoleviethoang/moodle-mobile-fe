import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/constants/dimens.dart';
import 'package:moodle_mobile/models/user_login.dart';
import 'package:moodle_mobile/sqllite/sql.dart';
import 'package:moodle_mobile/store/user/user_store.dart';

import 'package:moodle_mobile/view/direct_page.dart';

class UserLoginTile extends StatelessWidget {
  final UserLogin user;
  final UserStore userStore;
  final VoidCallback refresh;
  final BuildContext context;
  const UserLoginTile(
      {Key? key,
      required this.user,
      required this.userStore,
      required this.refresh,
      required this.context})
      : super(key: key);

  login() async {
    await userStore.setBaseUrl(user.baseUrl);

    await userStore.setUser(
      user.token,
      user.username,
    );

    if (userStore.isLogin == true && userStore.isLoading == false) {
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
                        child: user.photo != null
                            ? Image.network(
                                user.photo! + "&token=" + user.token,
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
                    const SizedBox(width: 15),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.username,
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            textScaleFactor: 1.5,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            user.baseUrl.replaceAll("https://", ""),
                            textScaleFactor: 1.1,
                          ),
                        ]),
                  ],
                ),
                IconButton(
                    onPressed: () async {
                      await SQLHelper.deleteUserItem(
                          user.baseUrl, user.username);
                      refresh();
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
