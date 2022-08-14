import 'dart:async';

import 'package:flutter/material.dart';
//import 'package:flutter_html/flutter_html.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/constants/styles.dart';
import 'package:moodle_mobile/constants/vars.dart';
import 'package:moodle_mobile/data/network/apis/course/course_detail_service.dart';
import 'package:moodle_mobile/data/network/apis/notification/notification_api.dart';
import 'package:moodle_mobile/models/course/course_detail.dart';
import 'package:moodle_mobile/models/notification/notification.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moodle_mobile/view/notifications/notification_detail_screen.dart';

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
  List<NotificationDetail> _notificationDetail = [];

  bool _loading = true;

  @override
  void initState() {
    _userStore = GetIt.instance<UserStore>();

    //getName();
    getData();
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
    late List<NotificationDetail> unRead = [];
    late List<NotificationDetail> alreadyRead = [];
    //get unread
    await NotificationApi.fetchPopup(_userStore.user.token,
            useridto: _userStore.user.id, read: 0)
        .then((value) {
      unRead = value!.notificationDetail!;
    });

    //get read
    await NotificationApi.fetchPopup(_userStore.user.token,
            useridto: _userStore.user.id)
        .then((value) async {
      //List<String> temp = [];
      //alreadyRead = value!.notificationDetail!;
      // setState(() => _loading = true);
      for (int i = 0; i < 5; i++) {
        if (i < value!.notificationDetail!.length) {
          if (value.notificationDetail![i] != null) {
            value.notificationDetail![i].read = true;
            alreadyRead.add(value.notificationDetail![i]);
          }
        } else
          break;
      }
      // int check = 0;
      // for (var t in value!.notificationDetail!) {
      //   if (t.customdata!.courseId != null) check++;
      // }
      // print(check);
      // for (NotificationDetail t in value!.notificationDetail!) {
      //   if (t.customdata != null) {
      //     if (t.customdata!.courseId != null) {
      //       await CourseDetailService()
      //           .getCourseById(_userStore.user.token, t.customdata!.courseId!)
      //           .then((value) {
      //         temp.add(value.displayname!);
      //       });
      //     } else
      //       temp.add('');
      //   } else
      //     temp.add('');
      // }
      setState(() {
        //name = temp;
        //_notificationPopup = value;
        _loading = false;
        //_notificationDetail = value.notificationDetail ?? [];
        _notificationDetail = unRead + alreadyRead;
      });
    });

    //await NotificationApi.markAllAsRead(_userStore.user.token);
    //getName();
  }

  getName() async {
    List<String> temp = [];
    for (var t in _notificationPopup!.notificationDetail!) {
      await CourseDetailService()
          .getCourseById(_userStore.user.token, t.customdata!.courseId!)
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
    //final notifications = _notificationPopup?.notificationDetail ?? [];
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
                  if (_notificationDetail.isEmpty)
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
                  ...List.generate(_notificationDetail.length, (index) {
                    final temp = _notificationDetail[index];

                    //get subject
                    String subject = temp.subject ?? '';
                    //subject = subject.substring(0, subject.indexOf(':'));
                    if (subject == '') return Container();
                    //get article
                    String article = temp.userFromFullName ?? '';
                    //article = article.substring(0, article.indexOf('posted'));

                    //get date
                    String date = DateFormat("dd/MM/yyyy")
                        .format(DateTime.fromMillisecondsSinceEpoch(
                            temp.timecreated! * 1000))
                        .toString();
                    //DateTime now = new DateTime.now();
                    // int duraDay = int.parse(date.substring(0, date.indexOf('days')));
                    // print(duraDay);

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: InkWell(
                        onTap: () async {
                          print(temp.notification);
                          if (temp.notification == 1) {
                            await NotificationApi.markNotifcationAsRead(
                                _userStore.user.token, temp.id!);
                          } else if (temp.notification == 0) {
                            await NotificationApi.markMessageAsRead(
                                _userStore.user.token,
                                temp.id!,
                                _userStore.user.id);
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return NotificationDetailScreen(
                                article: article,
                                content: temp.text,
                                subject: subject,
                              );
                            }),
                          ).then((_) => getData());
                        },
                        child: NotificationPopupContainer(
                            article: article,
                            subject: subject,
                            title: temp.contexturlname,
                            read: temp.read,
                            date: date),
                      ),
                    );
                  }),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 15, 12),
                      child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: MoodleColors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          //color: MoodleColors.blue,
                          width: double.infinity,
                          child: TextButton(
                              onPressed: () {},
                              child: Text('Submit',
                                  style: TextStyle(color: Colors.white)))),
                    ),
                  )
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
  //final String? name;
  final bool? read;

  const NotificationPopupContainer({
    this.subject,
    this.title,
    this.read,
    this.article,
    this.date,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 15, 15, 17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  read == true
                      ? Container()
                      : Icon(
                          Icons.circle,
                          color: MoodleColors.blue,
                          size: 13,
                        ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Text(
                      article!,
                      //overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          letterSpacing: 0.2),
                    ),
                  ),
                ],
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     Expanded(
              //       child: Html(
              //         data: AppLocalizations.of(context)!
              //             .noti_context(article ?? '', name ?? ''),
              //         style: {'*': Style(fontSize: const FontSize(12))},
              //       ),
              //     ),
              //     // IconButton(
              //     //   icon: const Icon(Icons.arrow_right),
              //     //   onPressed: () {
              //     //     Navigator.push(context,
              //     //         MaterialPageRoute(builder: (builder) {
              //     //       return ForumDetailScreen(
              //     //           DiscussionId: int.parse(temp!.discussionid!));
              //     //     }));
              //     //   },
              //     // )
              //   ],
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 10),
              //   child: Text(title ?? ' '),
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child:
                    Text(date!, style: MoodleStyles.notificationTimestampStyle),
              ),
              Text(
                subject!,
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
