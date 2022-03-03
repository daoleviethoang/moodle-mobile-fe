import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/components/custom_button.dart';
import 'package:moodle_mobile/components/custom_text_field.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/constants/dimens.dart';
import 'package:moodle_mobile/store/user/user_store.dart';

import 'home_design_course.dart';

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

  // Store
  late UserStore _userStore;

  @override
  void initState() {
    super.initState();

    _userStore = GetIt.instance<UserStore>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // Logo image
            Container(
              color: const Color(0xffF7F7F7),
              width: double.infinity,
              // MediaQuery: get 1/4 of screen height
              height: MediaQuery.of(context).size.height * 1 / 4,
              child: Image.asset('assets/image/logo.png'),
            ),

            // Username text field
            Padding(
                padding: const EdgeInsets.only(
                    left: Dimens.login_padding_left,
                    right: Dimens.login_padding_right),
                child: CustomTextFieldWidget(
                    hintText: "Username",
                    controller: usernameControler,
                    prefixIcon: Icons.people)),

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
                  prefixIcon: Icons.lock),
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
                  const Text("Remember account", style: TextStyle(fontSize: 16))
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
                        borderRadius: BorderRadius.all(
                            Radius.circular(Dimens.login_error_border_radius))),
                  ),
                ),
              );
            }),

            const SizedBox(height: Dimens.login_sizedbox_height),

            // Forget password button
            TextButton(
              onPressed: forgotPass,
              child: const Text(
                "Forgotten your username or password ?",
                style: TextStyle(fontSize: 14),
              ),
              style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all(Colors.orangeAccent)),
            )
          ],
        ),
      ),
    );
  }

  void onLoginPressed() {
    // Navigator.push(context, MaterialPageRoute(builder: (context) => DesignCourseHomeScreen()));
    _userStore.login(usernameControler.text, passwordController.text);
  }

  void forgotPass() {
    print("Forgot Password");
  }
}
