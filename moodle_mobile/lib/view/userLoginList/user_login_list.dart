import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/constants/dimens.dart';
import 'package:moodle_mobile/models/user_login.dart';
import 'package:moodle_mobile/sqllite/sql.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/common/custom_button.dart';
import 'package:moodle_mobile/view/login/login.dart';
import 'package:moodle_mobile/view/userLoginList/user_login_tile.dart';

class ListUserLoginScreen extends StatefulWidget {
  const ListUserLoginScreen({Key? key}) : super(key: key);

  @override
  State<ListUserLoginScreen> createState() => _ListUserLoginScreenState();
}

class _ListUserLoginScreenState extends State<ListUserLoginScreen> {
  List<UserLogin> users = [];
  late UserStore _userStore;
  bool isLoading = true;

  @override
  void initState() {
    _userStore = GetIt.instance<UserStore>();
    loadUsers();
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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

  loadUsers() async {
    setState(() {
      isLoading = true;
    });
    try {
      List<UserLogin> temp = await SQLHelper.getUserItems();
      setState(() {
        users = temp;
      });
    } catch (e) {
      if (kDebugMode) {
        print("error sql lite: $e");
      }
    }
    if (users.isEmpty) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
        return const LoginScreen();
      }));
    }
    setState(() {
      isLoading = false;
    });
  }

  loadUsers2() async {
    setState(() {
      isLoading = true;
    });
    try {
      List<UserLogin> temp = await SQLHelper.getUserItems();
      setState(() {
        users = temp;
      });
    } catch (e) {
      if (kDebugMode) {
        print("error sql lite: $e");
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [],
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Spacer(
                      flex: 2,
                    ),
                    Container(
                      width: double.infinity,
                      // MediaQuery: get 1/4 of screen height
                      height: MediaQuery.of(context).size.height * 1 / 4,
                      child: Image.asset('assets/image/logoOnly.png'),
                    ),
                    Spacer(),
                    SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints.tightFor(
                          height: 260,
                        ),
                        child: ListView(
                          padding: const EdgeInsets.only(top: 0),
                          shrinkWrap: true,
                          semanticChildCount: 3,
                          children: users
                              .map((e) => UserLoginTile(
                                    user: e,
                                    userStore: _userStore,
                                    refresh: loadUsers2,
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (_) {
                            return const LoginScreen();
                          }));
                        },
                        child: Text(
                          AppLocalizations.of(context)!.add_account,
                          style: const TextStyle(fontSize: 16),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(MoodleColors.blue),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                          minimumSize: MaterialStateProperty.all(
                              const Size.fromHeight(40.0)),
                          shape: MaterialStateProperty.all(
                              const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          Dimens.default_border_radius)))),
                        ),
                      ),
                    ),
                    Spacer(
                      flex: 2,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}