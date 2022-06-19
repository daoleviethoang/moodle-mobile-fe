import 'package:autocomplete_textfield_ns/autocomplete_textfield_ns.dart';
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
      TextEditingController(text: "Chương trình");

  final List<String> suggestionsData = [
    "https://courses.ctda.hcmus.edu.vn",
    "https://courses.fit.hcmus.edu.vn",
    "https://elearning.fit.hcmus.edu.vn",
  ];

  final List<String> suggestions = [
    "Chương trình đề án (CLC, CTT, VP)",
    "Chương trình đại trà",
    "Chương trình đào tạo từ xa",
  ];

  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(),
        body: KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // Logo image
                isKeyboardVisible
                    ? Container(
                        height: 10,
                      )
                    : Container(
                        color: MoodleColors.lightGray,
                        width: double.infinity,
                        // MediaQuery: get 1/4 of screen height
                        height: MediaQuery.of(context).size.height * 1 / 6,
                        child: Image.asset('assets/image/logo.png'),
                      ),

                // base url text field
                Padding(
                    padding: const EdgeInsets.only(
                        left: Dimens.login_padding_left,
                        right: Dimens.login_padding_right),
                    child: SimpleAutoCompleteTextField(
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.all(Dimens.default_padding_double),
                        hintText: "BaseUrl",
                        prefixIcon: Icon(Icons.language),
                        hintStyle: isKeyboardVisible
                            ? TextStyle(fontSize: 14)
                            : TextStyle(fontSize: 16),
                        labelText: "BaseUrl",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(Dimens.default_border_radius))),
                      ),
                      suggestions: suggestions,
                      controller: baseUrlController,
                      key: key,
                      textChanged: (text) {},
                      clearOnSubmit: false,
                      textSubmitted: (text) {},
                    )),

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

    int index = suggestions.indexOf(baseUrlController.text);
    if (index != -1) {
      _userStore.setBaseUrl(suggestionsData[index]);
    } else {
      _userStore.setBaseUrl(baseUrlController.text);
    }

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
