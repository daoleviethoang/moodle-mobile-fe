import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/data/network/apis/notification_preference/notification_preference_api.dart';
import 'package:moodle_mobile/models/message_preference/message_preference.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/message_preference/notification_preference_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    _initTabList();
    loadData();
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
    setState(() {
      isLoading = true;
    });
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
      final snackBar = SnackBar(
          content:
              Text(AppLocalizations.of(context)!.err_load_message_settings));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    setState(() {
      isLoading = false;
    });
  }

  blockMessage() async {
    try {
      await NotificationPreferenceApi()
          .setMessagePreferenceContact(_userStore.user.token, !blockContact);
      setState(() {
        blockContact = !blockContact;
      });
    } catch (e) {
      final snackBar = SnackBar(
          content:
              Text(AppLocalizations.of(context)!.err_load_message_settings));
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
            title: Text(
              AppLocalizations.of(context)!.message_settings,
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
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.restrict,
                  textScaleFactor: 1.3,
                ),
                const SizedBox(
                  height: 10,
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runAlignment: WrapAlignment.center,
                  children: [
                    Checkbox(
                        value: blockContact,
                        shape: const CircleBorder(),
                        activeColor: Colors.green,
                        onChanged: (value) async {
                          await blockMessage();
                        }),
                    Text(
                      AppLocalizations.of(context)!.restrict_contact,
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
                        shape: const CircleBorder(),
                        onChanged: (value) async {
                          await blockMessage();
                        }),
                    Text(
                      AppLocalizations.of(context)!.restrict_anyone,
                      textScaleFactor: 1.2,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : TabBar(
                        isScrollable: true,
                        controller: _tabController,
                        tabs: _tabs,
                        onTap: (value) => setState(() => _index = value),
                      ),
                const Divider(),
                _tabs.isNotEmpty
                    ? Column(
                        children: messagePreference?.preferences?.components
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
