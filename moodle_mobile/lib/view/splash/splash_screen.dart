import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/direct_page.dart';
import 'package:moodle_mobile/view/forum/add_post/add_post_screen.dart';
import 'package:moodle_mobile/view/home/home.dart';
import 'package:moodle_mobile/view/login/login.dart';

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
        return const AddPostScreen(
          courseId: 1876,
          forumId: 2971,
        );
      }));
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
        return const LoginScreen();
      }));
    }
  }
}
