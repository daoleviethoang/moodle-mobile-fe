import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/constants/dimens.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/common/custom_button.dart';
import 'package:moodle_mobile/view/common/custom_text_field.dart';
import 'package:moodle_mobile/view/direct_page.dart';
import 'package:moodle_mobile/view/forget_pass/forget_pass_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // isCheck check that checkbox is check or uncheck
  bool isCheck = false;

  // Create a text controler
  final TextEditingController usernameControler = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final TextEditingController baseUrlController =
      TextEditingController(text: "");

  final TextEditingController otherUrlController =
      TextEditingController(text: "https://");

  final List<String> suggestionsData = [
    "https://courses.ctda.hcmus.edu.vn",
    "https://courses.fit.hcmus.edu.vn",
    "https://elearning.fit.hcmus.edu.vn",
    "https://",
  ];

  final List<String> suggestions = [
    "Chương trình đề án (CLC, CTT, VP)",
    "Chương trình đại trà",
    "Chương trình đào tạo từ xa",
    "Other",
  ];

  bool otherUrl = false;

  final focusNode = FocusNode();
  final urlKey = GlobalKey();

  // Store
  late UserStore _userStore;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _userStore = GetIt.instance<UserStore>();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    focusNode.dispose();
    super.dispose();
  }

  _onAppLanguagePressed(BuildContext context) async {
    final root = Overlay.of(context)?.context.findRenderObject();
    final rb = urlKey.currentContext?.findRenderObject();
    final pos = (rb as RenderBox).localToGlobal(Offset.zero);

    var value = await showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(
          Offset(pos.dx, pos.dy) & const Size(64, 64),
          Offset.zero & (root as RenderBox).size),
      items: suggestions.map((e) {
        var index = suggestions.indexOf(e);
        return PopupMenuItem(
          value: suggestionsData[index],
          child: Text(suggestions[index]),
        );
      }).toList(),
    );
    if (value == null) {
      return;
    }
    if (suggestionsData.indexOf(value) == 3) {
      setState(() {
        otherUrl = true;
      });
      var check = await showDialog<bool>(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            titlePadding: const EdgeInsets.fromLTRB(20, 20, 10, 10),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Domain",
                  textScaleFactor: 0.8,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                CustomTextFieldWidget(
                  controller: otherUrlController,
                  hintText: AppLocalizations.of(context)!.enter_title,
                  haveLabel: false,
                  borderRadius: Dimens.default_border_radius,
                ),
              ],
            ),
            actions: [
              Row(children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                    },
                    child: Text(AppLocalizations.of(context)!.cancel,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        )),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(MoodleColors.grey),
                        shape: MaterialStateProperty.all(
                            const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0))))),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      FocusScope.of(dialogContext).unfocus();
                      Navigator.pop(dialogContext, true);
                    },
                    child: Text(AppLocalizations.of(context)!.ok,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        )),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(MoodleColors.blue),
                        shape: MaterialStateProperty.all(
                            const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0))))),
                  ),
                ),
              ]),
            ],
          );
        },
      );
      setState(() {
        otherUrl = false;
      });
      if (check == true) {
        setState(() {
          baseUrlController.text = otherUrlController.text;
        });
      }
    } else {
      setState(() {
        otherUrl = false;
        baseUrlController.text = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(),
        body: KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // Logo image
                isKeyboardVisible
                    ? !otherUrl
                        ? Container(
                            height: 10,
                          )
                        : Container(
                            color: MoodleColors.lightGray,
                            width: double.infinity,
                            // MediaQuery: get 1/4 of screen height
                            height: MediaQuery.of(context).size.height * 1 / 6,
                            child: Image.asset('assets/image/logo.png'),
                          )
                    : Container(
                        color: MoodleColors.lightGray,
                        width: double.infinity,
                        // MediaQuery: get 1/4 of screen height
                        height: MediaQuery.of(context).size.height * 1 / 6,
                        child: Image.asset('assets/image/logo.png'),
                      ),

                Padding(
                  padding: const EdgeInsets.only(
                      left: Dimens.login_padding_left,
                      right: Dimens.login_padding_right),
                  child: TextField(
                    key: urlKey,
                    focusNode: focusNode,
                    keyboardType: TextInputType.visiblePassword,
                    controller: baseUrlController,
                    readOnly: true,
                    maxLines: 1,
                    //readOnly: !canChangeUrl,
                    onTap: () async {
                      await _onAppLanguagePressed(context);
                    },
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.all(Dimens.default_padding_double),
                      prefixIcon: const Icon(Icons.language),
                      hintText: "BaseUrl",
                      labelText: "BaseUrl",
                      isDense: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(Dimens.default_border_radius))),
                    ),
                  ),
                ),

                const SizedBox(height: Dimens.login_sizedbox_height),

                // Username text field
                Padding(
                    padding: const EdgeInsets.only(
                        left: Dimens.login_padding_left,
                        right: Dimens.login_padding_right),
                    child: CustomTextFieldWidget(
                      hintText: "Username",
                      controller: usernameControler,
                      prefixIcon: Icons.people,
                      borderRadius: Dimens.default_border_radius,
                      fontSize: isKeyboardVisible ? 14 : 16,
                    )),

                const SizedBox(height: Dimens.login_sizedbox_height),

                // Password text field
                Padding(
                  padding: const EdgeInsets.only(
                      left: Dimens.login_padding_left,
                      right: Dimens.login_padding_right),
                  child: CustomTextFieldWidget(
                    hintText: "Password",
                    hidePass: true,
                    controller: passwordController,
                    prefixIcon: Icons.lock,
                    fontSize: isKeyboardVisible ? 14 : 16,
                    borderRadius: Dimens.default_border_radius,
                  ),
                ),

                const SizedBox(height: Dimens.login_sizedbox_height),

                // Remember check box
                Padding(
                  padding: const EdgeInsets.only(
                      left: Dimens.login_checkbox_padding_left),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: isCheck,
                        fillColor: MaterialStateProperty.all(MoodleColors.blue),
                        onChanged: (value) {
                          setState(() {
                            isCheck = !isCheck;
                          });
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                Dimens.default_checkbox_border_radius)),
                      ),
                      const Text("Remember account",
                          style: TextStyle(fontSize: 16))
                    ],
                  ),
                ),

                const SizedBox(height: Dimens.login_sizedbox_height),

                // Login button
                Padding(
                    padding: const EdgeInsets.only(
                        left: Dimens.login_checkbox_padding_left,
                        right: Dimens.login_padding_right),
                    child: CustomButtonWidget(
                        textButton: "Login", onPressed: onLoginPressed)),

                const SizedBox(height: Dimens.login_sizedbox_height),

                // Error message
                Observer(builder: (_) {
                  return Visibility(
                    maintainAnimation: true,
                    maintainSize: true,
                    maintainState: true,
                    visible: _userStore.isLoginFailed,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: Dimens.login_padding_left,
                          right: Dimens.login_padding_right),
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        width: double.infinity,
                        // MediaQuery: get 1/4 of screen height
                        child: const Text(
                          "Invalid login, please try again",
                          textAlign: TextAlign.center,
                        ),
                        decoration: const BoxDecoration(
                            color: MoodleColors.red_error_message,
                            borderRadius: BorderRadius.all(Radius.circular(
                                Dimens.login_error_border_radius))),
                      ),
                    ),
                  );
                }),

                // Forget password button
                isKeyboardVisible
                    ? Container()
                    : TextButton(
                        onPressed: forgotPass,
                        child: const Text(
                          "Forgot your username or password ?",
                          style: TextStyle(fontSize: 14),
                        ),
                        style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all(Colors.orangeAccent)),
                      )
              ],
            ),
          );
        }));
  }

  void onLoginPressed() async {
    FocusScope.of(context).unfocus();

    _userStore.setBaseUrl(baseUrlController.text);

    await _userStore.login(
      usernameControler.text,
      passwordController.text,
      isCheck,
    );

    if (_userStore.isLogin == true) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const DirectScreen();
          },
        ),
        (route) => false,
      );
    }
  }

  void forgotPass() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const ForgotPassScreen();
        },
      ),
    );
  }
}