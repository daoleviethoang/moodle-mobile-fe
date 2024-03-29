import 'package:flutter/material.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/common/user/description_common.dart';
import 'package:moodle_mobile/view/common/user/public_user_information_common.dart';
import 'package:moodle_mobile/view/common/user/user_detail_common.dart';

// class ProfileScreen extends Sta {
//   const ProfileScreen({Key? key}) : super(key: key);

//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }

class ProfileScreen extends StatelessWidget {
  final UserStore userStore;

  const ProfileScreen({Key? key, required this.userStore}) : super(key: key);

  // int _selectedIndex = 0;

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    var avatar = "";
    if (userStore.user.photo!.contains("?")) {
      avatar = userStore.user.photo! + "&token=" + userStore.user.token;
    } else {
      avatar = userStore.user.photo! + "?token=" + userStore.user.token;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              PublicInformationCommonView(
                imageUrl: avatar,
                name: userStore.user.fullname,
                userStore: userStore,
                canEditAvatar: true,
              ),
              UserDetailCommonView(
                email: userStore.user.email,
                location: userStore.user.country != null
                    ? userStore.user.country! + ", "
                    : "" + (userStore.user.city ?? ""),
              ),
              DescriptionCommonView(
                description: userStore.user.description != null
                    ? userStore.user.description!
                    : "",
              ),
            ],
          ),
        ),
      ),
    );
  }
}