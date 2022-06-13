import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:moodle_mobile/constants/styles.dart';
import 'package:moodle_mobile/constants/vars.dart';
import 'package:moodle_mobile/data/network/apis/course/course_detail_service.dart';
import 'package:moodle_mobile/data/network/apis/notification/notification_api.dart';
import 'package:moodle_mobile/models/course/course_detail.dart';
import 'package:moodle_mobile/models/notification/notification.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationPopup? _notificationPopup;
  late UserStore _userStore;
  late Timer _refreshTimer;
  late CourseDetail _courseDetail;
  List<String>? name;

  bool _loading = true;

  @override
  void initState() {
    _userStore = GetIt.instance<UserStore>();
    getData();
    //getName();
    super.initState();

    // Update notification list
    _refreshTimer = Timer.periodic(Vars.refreshInterval, (t) => getData());
  }

  @override
  void dispose() {
    _refreshTimer.cancel();
    super.dispose();
  }

  getData() async {
    await NotificationApi.fetchPopup(_userStore.user.token).then((value) async {
      List<String> temp = [];
      setState(() => _loading = true);
      for (var t in value!.notificationDetail!) {
        await CourseDetailService()
            .getCourseById(
                _userStore.user.token, int.parse(t.customdata!.courseId!))
            .then((value) {
          temp.add(value.displayname!);
        });
      }
      setState(() {
        _notificationPopup = value;
        name = temp;
        _loading = false;
      });
    });
    //getName(temp!);
  }

  getName() async {
    print(_notificationPopup);
    List<String> temp = [];
    for (var t in _notificationPopup!.notificationDetail!) {
      await CourseDetailService()
          .getCourseById(
              _userStore.user.token, int.parse(t.customdata!.courseId!))
          .then((value) {
        temp.add(value.displayname!);
      });
    }
    setState(() {
      name = temp;
      _loading = !_loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifications = _notificationPopup?.notificationDetail ?? [];
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => getData(),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  if (notifications.isEmpty)
                    Expanded(
                      child: Opacity(
                        opacity: .5,
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.nothing_yet,
                          ),
                        ),
                      ),
                    ),

                  ...List.generate(notifications.length, (index) {
                    final temp = notifications[index];

                    //get subject
                    String subject = temp.subject!;
                    subject = subject.substring(0, subject.indexOf(':'));

                    //get article
                    String article = temp.smallmessage!;
                    article = article.substring(0, article.indexOf('posted'));

                    //get date
                    String date = DateFormat("dd-MM-yyyy")
                        .format(DateTime.fromMillisecondsSinceEpoch(
                            temp.timecreated! * 1000))
                        .toString();
                    //DateTime now = new DateTime.now();
                    // int duraDay = int.parse(date.substring(0, date.indexOf('days')));
                    // print(duraDay);

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: NotificationPopupContainer(
                          name: name![index],
                          article: article,
                          subject: subject,
                          title: temp.contexturlname,
                          date: date),
                    );
                  })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationPopupContainer extends StatelessWidget {
  final String? date;
  final String? title;
  final String? subject;
  final String? article;
  final String? name;

  const NotificationPopupContainer({
    this.subject,
    this.title,
    this.name = 'temp',
    this.article,
    this.date,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      subject!,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Card(
                      color: Colors.blue[50],
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(date!,
                            style: MoodleStyles.notificationTimestampStyle),
                      )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Html(
                      data: AppLocalizations.of(context)!
                          .noti_context(article ?? '', name ?? ''),
                      style: {'*': Style(fontSize: const FontSize(12))},
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_right),
                    onPressed: () {},
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(title ?? ' '),
              ),
            ],
          ),
        ),
      ),
    );
  }
}