import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/constants/dimens.dart';
import 'package:moodle_mobile/data/network/apis/enroll/enroll_api.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/common/custom_button.dart';
import 'package:moodle_mobile/view/common/custom_text_field.dart';
import 'package:moodle_mobile/view/course_details.dart';

class EnrollScreen extends StatefulWidget {
  final int courseId;
  const EnrollScreen({Key? key, required this.courseId}) : super(key: key);

  @override
  State<EnrollScreen> createState() => _EnrollScreenState();
}

class _EnrollScreenState extends State<EnrollScreen> {
  late UserStore _userStore;
  TextEditingController enrollController = TextEditingController();

  enroll() async {
    bool check = await EnrollApi()
        .enroll(_userStore.user.token, widget.courseId, enrollController.text);
    if (check) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) {
            return CourseDetailsScreen(
              courseId: widget.courseId,
            );
          },
        ),
      );
    } else {
      const snackBar = SnackBar(content: Text("Enroll key not correct"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void initState() {
    _userStore = GetIt.instance<UserStore>();
    super.initState();
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
              "Enroll",
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
        body: Padding(
            padding: const EdgeInsets.only(
                left: Dimens.login_padding_left,
                right: Dimens.login_padding_right),
            child: Wrap(
              runAlignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  "You are not a participant of this course.",
                  textScaleFactor: 1.4,
                ),
                SizedBox(height: 40),
                CustomTextFieldWidget(
                  hintText: "Enroll pass",
                  hidePass: true,
                  controller: enrollController,
                  prefixIcon: Icons.lock,
                  borderRadius: Dimens.default_border_radius,
                ),
                SizedBox(height: 60),
                CustomButtonWidget(
                  textButton: "Enroll",
                  onPressed: () async {
                    await enroll();
                  },
                ),
              ],
            )),
      ),
    );
  }
}
