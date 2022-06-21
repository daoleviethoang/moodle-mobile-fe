import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/data/network/apis/notification_preference/notification_preference_api.dart';
import 'package:moodle_mobile/models/notification_preference/notification_preference.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/notification_preference/notification_preference_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationPreferenceScreen extends StatefulWidget {
  const NotificationPreferenceScreen({
    Key? key,
  }) : super(key: key);

  @override
  _NotificationPreferenceScreenState createState() =>
      _NotificationPreferenceScreenState();
}

class _NotificationPreferenceScreenState
    extends State<NotificationPreferenceScreen> with TickerProviderStateMixin {
  bool isLoading = false;
  bool disableAll = false;
  NotificationPreference? notificationPreference;
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

  loadData() async {
    setState(() {
      isLoading = true;
    });
    NotificationPreference? temp;
    try {
      temp = await NotificationPreferenceApi().getData(_userStore.user.token);
      setState(() {
        notificationPreference = temp;
        disableAll = notificationPreference?.disableall == 1;
      });
      _initTabList();
    } catch (e) {
      final snackBar = SnackBar(
          content: Text(AppLocalizations.of(context)!.err_load_noti_settings));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    setState(() {
      isLoading = false;
    });
  }

  setAllNotification() async {
    try {
      await NotificationPreferenceApi()
          .setAllNotificationPreference(_userStore.user.token, !disableAll);
      setState(() {
        disableAll = !disableAll;
      });
    } catch (e) {
      print(e.toString());
      final snackBar = SnackBar(
          content: Text(AppLocalizations.of(context)!.err_set_noti_settings));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _initTabList() {
    _tabs = notificationPreference?.processors
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            snap: true,
            title: Text(
              AppLocalizations.of(context)!.noti_settings,
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
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: MoodleColors.grey_soft),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SwitchListTile(
                    title: Text(AppLocalizations.of(context)!.disable_noti),
                    value: disableAll,
                    onChanged: (value) async {
                      await setAllNotification();
                    },
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : TabBar(
                        isScrollable: true,
                        controller: _tabController,
                        tabs: _tabs,
                        onTap: (value) => setState(() => _index = value),
                      ),
                Divider(),
                if (_tabs.isNotEmpty)
                  Column(
                    children: notificationPreference?.components
                            ?.map((e) => NotificationPreferenceTile(
                                preferenceName: notificationPreference!
                                    .processors![_index].displayname!,
                                disable: disableAll,
                                components: e))
                            .toList() ??
                        [],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}