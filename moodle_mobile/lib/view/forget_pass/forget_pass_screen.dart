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
  ];

  bool otherUrl = false;

  final focusNode = FocusNode();
  final urlKey = GlobalKey();

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
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => setState(
        () {
          suggestions.add(AppLocalizations.of(context)!.other);
        },
      ),
    );
    super.initState();
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
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
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
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.all(Dimens.default_padding_double),
                  prefixIcon: const Icon(Icons.language),
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
                )),

            const SizedBox(height: Dimens.login_sizedbox_height),

            // Login button
            Padding(
              padding: const EdgeInsets.only(
                  left: Dimens.login_checkbox_padding_left,
                  right: Dimens.login_padding_right),
              child: CustomButtonWidget(
                textButton: AppLocalizations.of(context)!.send_forgot_link,
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
