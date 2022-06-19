import 'package:autocomplete_textfield_ns/autocomplete_textfield_ns.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/constants/dimens.dart';
import 'package:moodle_mobile/data/network/apis/forgot_pass/forgot_api.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/common/custom_button.dart';
import 'package:moodle_mobile/view/common/custom_text_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgotPassScreen extends StatefulWidget {
  const ForgotPassScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPassScreen> createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  late UserStore _userStore;
  TextEditingController usernameControler = TextEditingController();
  final TextEditingController baseUrlController =
      TextEditingController(text: "https://");

  final List<String> suggestions = [
    "https://courses.ctda.hcmus.edu.vn",
    "https://courses.fit.hcmus.edu.vn",
    "https://elearning.fit.hcmus.edu.vn",
  ];

  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();

  sendLinkForgotPass() async {
    FocusScope.of(context).unfocus();
    _userStore.setBaseUrl(baseUrlController.text);
    try {
      String? check = await ForgotPassApi().forgotPass(usernameControler.text);
      if (check == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.user_not_exist),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(check),
          backgroundColor: Colors.green,
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // Logo image
            Container(
              color: MoodleColors.lightGray,
              width: double.infinity,
              // MediaQuery: get 1/4 of screen height
              height: MediaQuery.of(context).size.height * 1 / 4,
              child: Image.asset('assets/image/logo.png'),
            ),

            // base url text field
            Padding(
                padding: const EdgeInsets.only(
                    left: Dimens.login_padding_left,
                    right: Dimens.login_padding_right),
                child: SimpleAutoCompleteTextField(
                  textInputAction: TextInputAction.search,
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.all(Dimens.default_padding_double),
                    hintText: "BaseUrl",
                    labelText: "BaseUrl",
                    prefixIcon: Icon(Icons.language),
                    hintStyle: TextStyle(fontSize: 16),
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
                )),

            const SizedBox(height: Dimens.login_sizedbox_height),

            // Login button
            Padding(
              padding: const EdgeInsets.only(
                  left: Dimens.login_checkbox_padding_left,
                  right: Dimens.login_padding_right),
              child: CustomButtonWidget(
                textButton: "Send link",
                onPressed: () async {
                  await sendLinkForgotPass();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
