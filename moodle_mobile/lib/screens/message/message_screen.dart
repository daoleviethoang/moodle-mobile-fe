import 'package:flutter/material.dart';
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
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text("Messenger"),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.amber)),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: TextButton(
                      onPressed: () {},
                      child: const Text("Contact"),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.amber))),
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
