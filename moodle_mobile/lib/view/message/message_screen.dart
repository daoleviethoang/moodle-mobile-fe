import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/view/common/custom_button_short.dart';
import 'package:moodle_mobile/view/common/message/contact_list.dart';
import 'package:moodle_mobile/view/common/message/message_list.dart';
import 'package:moodle_mobile/view/common/slidable_tile.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/constants/dimens.dart';
import 'package:moodle_mobile/data/repository.dart';
import 'package:moodle_mobile/view/message/message_detail_screen.dart';
import 'package:moodle_mobile/store/conversation/conversation_store.dart';
import 'package:moodle_mobile/store/conversation_detail/conversation_detail_store.dart';
import 'package:moodle_mobile/store/user/user_store.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  // Tai day khai bao cac store ma ta se su dung
  int currentTab = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(width: 12),
                Expanded(
                  child: CustomButtonShort(
                      text: "Message",
                      textColor:
                          currentTab == 0 ? MoodleColors.blue : Colors.black,
                      bgColor: currentTab == 0
                          ? MoodleColors.brightGray
                          : MoodleColors.white,
                      blurRadius: 3,
                      onPressed: () {
                        setState(() {
                          currentTab = 0;
                        });
                      }),
                ),
                Container(width: 12),
                Expanded(
                  child: CustomButtonShort(
                      text: "Contact",
                      textColor:
                          currentTab == 0 ? Colors.black : MoodleColors.blue,
                      bgColor: currentTab == 0
                          ? MoodleColors.white
                          : MoodleColors.brightGray,
                      blurRadius: 3,
                      onPressed: () {
                        setState(() {
                          currentTab = 1;
                        });
                      }),
                ),
                Container(width: 12),
              ],
            ),
          ),
          currentTab == 0 ? MessageList() : ContactList()
        ],
      ),
    );
  }

  void onSearchContact() {
    print("Search is on");
  }
}
