import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
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
  }

  loadUsers() async {
    try {
      List<UserLogin> temp = await SQLHelper.getUserItems();
      setState(() {
        users = temp;
      });
    } catch (e) {
      print("error sql lite");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          const SliverAppBar(
            floating: true,
            snap: true,
            title: Text(
              "List user login",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ],
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ListView(
                    padding: const EdgeInsets.only(top: 0),
                    shrinkWrap: true,
                    children: users
                        .map((e) =>
                            UserLoginTile(user: e, userStore: _userStore))
                        .toList(),
                  ),
                  CustomButtonWidget(
                    textButton: 'Add another account',
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacement(MaterialPageRoute(builder: (_) {
                        return const LoginScreen();
                      }));
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
