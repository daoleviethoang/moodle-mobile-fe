import 'package:flutter/material.dart';
import 'package:moodle_mobile/components/custom_button_short.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/constants/dimens.dart';

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
            padding: const EdgeInsets.only(top: Dimens.default_padding),
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
          )
        ],
      ),
    );
  }

  void onSearchContact() {
    print("Search is on");
  }
}
