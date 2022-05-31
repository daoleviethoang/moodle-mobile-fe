import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/constants/dimens.dart';
import 'package:moodle_mobile/data/network/apis/enrol/enrol_api.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/common/custom_button.dart';
import 'package:moodle_mobile/view/common/custom_text_field.dart';
import 'package:moodle_mobile/view/course_details.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EnrolScreen extends StatefulWidget {
  final int courseId;
  const EnrolScreen({Key? key, required this.courseId}) : super(key: key);

  @override
  State<EnrolScreen> createState() => _EnrolScreenState();
}

class _EnrolScreenState extends State<EnrolScreen> {
  late UserStore _userStore;
  bool isLoading = true;
  bool? havePass;
  TextEditingController enrollController = TextEditingController();

  enroll() async {
    bool check = await EnrolApi()
        .enrol(_userStore.user.token, widget.courseId, enrollController.text);
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.enrol_key_not_correct)));
    }
  }

  @override
  void initState() {
    _userStore = GetIt.instance<UserStore>();
    loadData();
    super.initState();
  }

  loadData() async {
    bool? check =
        await EnrolApi().haveEnrolPass(_userStore.user.token, widget.courseId);
    setState(() {
      havePass = check;
      isLoading = false;
    });
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
              AppLocalizations.of(context)!.enrol,
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
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.only(
                    left: Dimens.login_padding_left,
                    right: Dimens.login_padding_right),
                child: Wrap(
                  runAlignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.not_participant_course,
                      textScaleFactor: 1.4,
                    ),
                    havePass != true ? Container() : const SizedBox(height: 40),
                    havePass != true
                        ? Container()
                        : CustomTextFieldWidget(
                            hintText: AppLocalizations.of(context)!.enrol_pass,
                            hidePass: true,
                            controller: enrollController,
                            prefixIcon: Icons.lock,
                            borderRadius: Dimens.default_border_radius,
                          ),
                    havePass != true
                        ? const SizedBox(height: 20)
                        : const SizedBox(height: 60),
                    havePass == null
                        ? Text(
                            AppLocalizations.of(context)!.course_can_not_enrol,
                            textScaleFactor: 1.3,
                          )
                        : CustomButtonWidget(
                            textButton: AppLocalizations.of(context)!.enrol,
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
