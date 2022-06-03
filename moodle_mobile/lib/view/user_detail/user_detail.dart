import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/data/network/apis/user/user_api.dart';
import 'package:moodle_mobile/data/network/dio_client.dart';
import 'package:moodle_mobile/di/service_locator.dart';
import 'package:moodle_mobile/models/user/user_overview.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/common/user/course_common.dart';
import 'package:moodle_mobile/view/common/user/public_user_information_common.dart';
import 'package:moodle_mobile/view/common/user/status_common.dart';
import 'package:moodle_mobile/view/common/user/user_detail_common.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/*
UserDetailsScreen(
        avatar:
            'https://meta.vn/Data/image/2021/08/17/con-vit-vang-tren-fb-la-gi-trend-anh-avatar-con-vit-vang-la-gi-3.jpg',
        role: 'Teacher',
        course: 'Đồ án tốt nghiệp',
        email: 'lqvu@fit.hcmus.edu.vn',
        location: 'TP.HCM, Vietnam',
        name: 'Lâm Quang Vũ',
        status: 'Last online 22 hours ago',
      ),
*/

class UserDetailsScreen extends StatefulWidget {
  int id;
  final UserStore userStore;
  String? courseName;

  UserDetailsScreen(
      {Key? key,
      required this.id,
      required this.userStore,
      required this.courseName})
      : super(key: key);

  @override
  _UserDetailsScreen createState() => _UserDetailsScreen(id, userStore);
}

class _UserDetailsScreen extends State<UserDetailsScreen> {
  int id;
  late String avatar;
  late String name;
  late String status;
  late String? course;
  late String role;
  late String email;
  late String location;
  late bool isOnline;
  final UserStore userStore;

  bool isLoad = false;

  _UserDetailsScreen(this.id, this.userStore);

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MoodleColors.white,
      appBar: AppBar(
        backgroundColor: MoodleColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: isLoad
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    PublicInfomationCommonView(
                      imageUrl: avatar,
                      name: name,
                      userStore: userStore,
                      canEditAvatar: false,
                    ),
                    StatusCommonView(
                        status: status,
                        color: isOnline
                            ? MoodleColors.green_icon_status
                            : MoodleColors.grey_icon_status),
                    CourseCommonView(
                      role: role,
                      course: course,
                    ),
                    UserDetailCommonView(
                      email: email,
                      location: location,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  getData() async {
    setState(() {
      isLoad = true;
    });
    DateTime currentPhoneDate = DateTime.now(); //DateTime
    int currentTimeStamp =
        Timestamp.fromDate(currentPhoneDate).seconds; //To TimeStamp
    try {
      List<UserOverview> users = await UserApi(getIt<DioClient>())
          .getUserById(userStore.user.token, id);
      UserOverview user = users[0];
      if (user.profileimageurl != null) {
        user.profileimageurl = user.profileimageurl!
            .replaceAll("pluginfile.php", "webservice/pluginfile.php");
      }

      if (user.profileimageurl!.contains("?")) {
        avatar = user.profileimageurl! + "&token=" + userStore.user.token;
      } else {
        avatar = user.profileimageurl! + "?token=" + userStore.user.token;
      }

      name = user.fullname!;
      int calTime = currentTimeStamp - user.lastaccess!;
      if (calTime <= 300) {
        status = AppLocalizations.of(context)!.online_just_now;
        isOnline = true;
      } else {
        status = readTimestamp(user.lastaccess!);
        isOnline = false;
      }
      role = AppLocalizations.of(context)!.teacher;

      email = user.email!;
      String city = user.city != null ? user.city! + ", " : "";
      String country = user.country != null ? user.country! : "";
      location = city + country;

      setState(() {
        avatar = avatar;
        name = name;
        status = status;
        course = widget.courseName;
        role = role;
        email = email;
        location = location;
        isLoad = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
    }
  }

  String readTimestamp(int timestamp) {
    var now = DateTime.now();
    var format = DateFormat('HH:mm a');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = 'Last online ' + diff.inDays.toString() + ' days ago';
      } else {
        time = 'Last online ' + diff.inDays.toString() + ' days ago';
      }
    } else {
      if (diff.inDays == 7) {
        time =
            'Last online ' + (diff.inDays / 7).floor().toString() + ' week ago';
      } else {
        time = 'Last online ' +
            (diff.inDays / 7).floor().toString() +
            ' weeks ago';
      }
    }

    return time;
  }
}
