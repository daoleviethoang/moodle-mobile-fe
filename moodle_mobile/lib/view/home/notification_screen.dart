import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:moodle_mobile/data/network/apis/notification/notification_api.dart';
import 'package:moodle_mobile/di/service_locator.dart';
import 'package:moodle_mobile/models/notification/notification.dart';
import 'package:moodle_mobile/store/user/user_store.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late NotificationPopup _notificationPopup;
  late UserStore _userStore;

  @override
  void initState() {
    // TODO: implement initState
    _userStore = GetIt.instance<UserStore>();
    super.initState();
    NotificationApi.fetchPopup(_userStore.user.token).then((value) {
      setState(() {
        _notificationPopup = value as NotificationPopup;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ...List.generate(_notificationPopup.notificationDetail!.length,
              (index) {
            NotificationDetail temp =
                _notificationPopup.notificationDetail![index];

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

            return NotificationPopupContainer(
                article: article,
                subject: subject,
                title: temp.contexturlname,
                date: date);
          })
        ],
      ),
    );
  }
}

class NotificationPopupContainer extends StatelessWidget {
  final String? date;
  final String? title;
  final String? subject;
  final String? article;

  const NotificationPopupContainer({
    this.subject,
    this.title,
    this.article,
    this.date,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 10,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.2,
          padding: EdgeInsets.only(top: 8, right: 5, left: 18, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    subject!,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Card(
                      elevation: 5,
                      color: Colors.blue[50],
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: Text(date!),
                      )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: RichText(
                          text: TextSpan(
                              style:
                                  TextStyle(fontSize: 12, color: Colors.black),
                              children: [
                                TextSpan(
                                    text: article,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(
                                  text: 'posted in ',
                                ),
                                TextSpan(
                                    text: 'quản trị cơ sở dữ liệu',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ]),
                        ),
                      ),
                    ],
                  ),
                  IconButton(onPressed: () {}, icon: Icon(Icons.arrow_right))
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: RichText(
                  text: TextSpan(
                      style: TextStyle(fontSize: 14, color: Colors.black),
                      children: [
                        TextSpan(
                            text: 'hiện đại:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                          text: '[' + title! + ']',
                        ),
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
