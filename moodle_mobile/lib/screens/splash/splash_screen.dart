import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/screens/login/login.dart';
import 'package:moodle_mobile/screens/message/message_screen.dart';
import 'package:moodle_mobile/store/user/user_store.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late UserStore _userStore;
  @override
  void initState() {
    super.initState();

    _userStore = GetIt.instance<UserStore>();
    checkUserLogin();
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Future checkUserLogin() async {
    await _userStore.checkIsLogin();

    if (_userStore.isLogin) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
        return const MessageScreen();
      }));
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
        return const LoginScreen();
      }));
    }
  }
}
