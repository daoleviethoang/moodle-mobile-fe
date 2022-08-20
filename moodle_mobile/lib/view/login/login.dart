import 'package:charset/charset.dart';
import 'package:flutter/foundation.dart';
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

  // Check _initSuggestions()
  final List<String> suggestionsData = [];
  final List<String> suggestions = [];

  IconData programDropdownIcon = Icons.arrow_right;

  bool otherUrl = false;

  final focusNode = FocusNode();
  final urlKey = GlobalKey();

  // Store
  late UserStore _userStore;

  void _initSuggestions(BuildContext context) {
    suggestionsData.clear();
    suggestions.clear();

    suggestionsData.addAll([
      "https://courses.ctda.hcmus.edu.vn",
      "https://courses.fit.hcmus.edu.vn",
      "https://elearning.fit.hcmus.edu.vn",
      "https://",
    ]);
    suggestions.addAll([
      AppLocalizations.of(context)!.ctda_program,
      AppLocalizations.of(context)!.common_program,
      AppLocalizations.of(context)!.e_learing_program,
      AppLocalizations.of(context)!.other,
    ]);

    // Testing domain
    suggestionsData.add('https://courses.hcmus.edu.vn/lms');
    suggestions.add('Server thử nghiệm');
    baseUrlController.text = suggestionsData[4];
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => setState(() => _initSuggestions(context)),
    );
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
          Offset(pos.dx, pos.dy + rb.size.height) & const Size(64, 64),
          Offset.zero & (root as RenderBox).size),
      constraints: const BoxConstraints(minWidth: double.infinity),
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
                  AppLocalizations.of(context)!.domain,
                  textScaleFactor: 0.8,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
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
                        style: const TextStyle(
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
                        style: const TextStyle(
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
          programDropdownIcon = Icons.arrow_right;
        });
      }
    } else {
      setState(() {
        otherUrl = false;
        baseUrlController.text = value;
        programDropdownIcon = Icons.arrow_right;
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

                //Site
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
                      setState(() {
                        programDropdownIcon = Icons.arrow_drop_down;
                      });
                      await _onAppLanguagePressed(context);
                    },
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.all(Dimens.default_padding_double),
                      prefixIcon: const Icon(Icons.language),
                      suffixIcon: Icon(programDropdownIcon),
                      hintText: AppLocalizations.of(context)!.baseUrl,
                      labelText: AppLocalizations.of(context)!.baseUrl,
                      isDense: true,
                      border: const OutlineInputBorder(
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
                      hintText: AppLocalizations.of(context)!.username,
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
                    hintText: AppLocalizations.of(context)!.password,
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
                      Text(AppLocalizations.of(context)!.remember_account,
                          style: const TextStyle(fontSize: 16))
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
                        textButton: AppLocalizations.of(context)!.login,
                        onPressed: onLoginPressed)),

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
                        child: Text(
                          AppLocalizations.of(context)!.login_invalid,
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
                        child: Text(
                          AppLocalizations.of(context)!.forgot_password,
                          style: const TextStyle(fontSize: 16),
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

    if (baseUrlController.text.isEmpty) {
      baseUrlController.text = suggestionsData[4];
    }
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
