import 'dart:html';

import 'package:flutter/material.dart';
import 'package:moodle_mobile/components/custom_button_short.dart';
import 'package:moodle_mobile/components/slidable_tile.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/constants/dimens.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Change state of back button to false .... Remove back button
        automaticallyImplyLeading: false,
        title: const Text("Messenger", style: TextStyle(color: Colors.white)),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: onSearchContact,
            icon: const Icon(Icons.search),
            color: Colors.white,
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButtonShort(
                    text: "Message",
                    textColor: MoodleColors.blue,
                    bgColor: MoodleColors.brightGray,
                    blurRadius: 10.0,
                    onPressed: () {}),
                CustomButtonShort(
                    text: "Contact",
                    textColor: Colors.black,
                    bgColor: Colors.white,
                    blurRadius: 4.0,
                    onPressed: () {}),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding:
                  const EdgeInsets.only(top: Dimens.default_padding_double),
              children: [
                SlidableTile(
                  isNotification: false,
                  nameInfo: "Nguyen Gia Hung",
                  messContent: "Send you a message - 2/10/2021",
                  onDeletePress: () {
                    print("Delete chat of Nguyen Gia Hung");
                  },
                  onAlarmPress: () {
                    print("Turn on/off alarm");
                  },
                  onMessDetailPress: () {
                    print("Conversation Detail");
                  },
                ),
                SlidableTile(
                  isNotification: false,
                  nameInfo: "Ngo Thi Thanh Thao",
                  messContent: "Send you a message - 2/10/2021",
                  onDeletePress: () {
                    print("Delete chat of Ngo Thi Thanh Thao");
                  },
                  onAlarmPress: () {
                    print("Turn on/off alarm");
                  },
                  onMessDetailPress: () {
                    print("Conversation Detail");
                  },
                ),
                SlidableTile(
                  isNotification: false,
                  nameInfo: "Le Thanh Binh",
                  messContent: "Send you a message - 2/10/2021",
                  onDeletePress: () {
                    print("Delete chat of Le Thanh Binh");
                  },
                  onAlarmPress: () {
                    print("Turn on/off alarm");
                  },
                  onMessDetailPress: () {
                    print("Conversation Detail");
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void onSearchContact() {
    print("Search is on");
  }
}
