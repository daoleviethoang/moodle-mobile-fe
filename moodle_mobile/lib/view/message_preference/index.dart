import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/data/network/apis/notification_preference/notification_preference_api.dart';
import 'package:moodle_mobile/models/message_preference/message_preference.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/message_preference/notification_preference_tile.dart';

class MessagePreferenceScreen extends StatefulWidget {
  const MessagePreferenceScreen({
    Key? key,
  }) : super(key: key);

  @override
  _MessagePreferenceScreenState createState() =>
      _MessagePreferenceScreenState();
}

class _MessagePreferenceScreenState extends State<MessagePreferenceScreen>
    with TickerProviderStateMixin {
  bool isLoading = false;
  bool disableAll = false;
  bool blockContact = false;
  MessagePreference? messagePreference;
  late UserStore _userStore;
  var _tabs = <Widget>[];
  late TabController _tabController;
  int _index = 0;

  @override
  void initState() {
    _userStore = GetIt.instance<UserStore>();
    super.initState();
    setState(() {
      isLoading = true;
    });
    _initTabList();
    loadData();
    setState(() {
      isLoading = false;
    });
  }

  @override
  dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _initTabList() {
    _tabs = messagePreference?.preferences?.processors
            ?.map((e) => Tab(
                  child: Text(e.displayname ?? "",
                      style: const TextStyle(
                        color: Colors.black,
                      )),
                ))
            .toList() ??
        [];
    _tabController = TabController(
      length: _tabs.length,
      initialIndex: _index,
      vsync: this,
    );
  }

  loadData() async {
    MessagePreference? temp;
    try {
      temp = await NotificationPreferenceApi()
          .getMessagePreference(_userStore.user.token);
      setState(() {
        messagePreference = temp;
        blockContact = (temp?.blocknoncontacts ?? 1) == 1 ? true : false;
        disableAll = (temp?.preferences?.disableall ?? 1) == 1 ? true : false;
      });
      _initTabList();
    } catch (e) {
      const snackBar = SnackBar(
          content:
              Text("Loading message preferences fail, please try again later"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  blockMessage() async {
    try {
      await NotificationPreferenceApi()
          .setMessagePreferenceContact(_userStore.user.token, !blockContact);
      setState(() {
        blockContact = !blockContact;
      });
    } catch (e) {
      const snackBar = SnackBar(
          content:
              Text("Loading message preferences fail, please try again later"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            snap: true,
            title: const Text(
              "Message notification",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            leading: TextButton(
              style: TextButton.styleFrom(
                primary: Colors.white,
              ),
              child: const Icon(CupertinoIcons.back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "You can restrict who can message you",
                        textScaleFactor: 1.3,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        runAlignment: WrapAlignment.center,
                        children: [
                          Checkbox(
                              value: blockContact,
                              shape: CircleBorder(),
                              activeColor: Colors.green,
                              onChanged: (value) async {
                                await blockMessage();
                              }),
                          Text(
                            "My contacts only",
                            textScaleFactor: 1.2,
                          ),
                        ],
                      ),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        runAlignment: WrapAlignment.center,
                        children: [
                          Checkbox(
                              value: !blockContact,
                              activeColor: Colors.green,
                              shape: CircleBorder(),
                              onChanged: (value) async {
                                await blockMessage();
                              }),
                          Text(
                            "My contacts and anyone in my courses",
                            textScaleFactor: 1.2,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TabBar(
                        isScrollable: true,
                        controller: _tabController,
                        tabs: _tabs,
                        onTap: (value) => setState(() => _index = value),
                      ),
                      Divider(),
                      _tabs.isNotEmpty
                          ? Column(
                              children: messagePreference
                                      ?.preferences?.components
                                      ?.map((e) => MessagePreferenceTile(
                                          preferenceName: messagePreference!
                                              .preferences!
                                              .processors![_index]
                                              .displayname!,
                                          disable: disableAll,
                                          components: e))
                                      .toList() ??
                                  [],
                            )
                          : Container()
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
