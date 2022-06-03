import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/data/network/apis/file/file_api.dart';
import 'package:moodle_mobile/data/network/apis/user/user_api.dart';
import 'package:moodle_mobile/data/network/dio_client.dart';
import 'package:moodle_mobile/models/user_login.dart';
import 'package:moodle_mobile/sqllite/sql.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/common/image_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PublicInfomationCommonView extends StatelessWidget {
  final String imageUrl;
  final String name;
  final UserStore userStore;
  final bool canEditAvatar;

  const PublicInfomationCommonView(
      {Key? key,
      required this.imageUrl,
      required this.name,
      required this.userStore,
      required this.canEditAvatar})
      : super(key: key);

  pickAndUploadImage(BuildContext context) async {
    try {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null) {
        PlatformFile file = result.files.first;
        if (file.path != null) {
          int itemId = await FileApi()
              .uploadFile(userStore.user.token, file.path!, null, null);
          bool check = await UserApi(DioClient(Dio()))
              .uploadAvatar(userStore.user.token, itemId);
          if (check) {
            await userStore.reGetUserInfo(
                userStore.user.token, userStore.user.username);
            SQLHelper.updateUserPhoto(UserLogin(
                token: userStore.user.token,
                baseUrl: userStore.user.baseUrl,
                username: userStore.user.username,
                photo: userStore.user.photo));
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Upload avatar fail"),
                backgroundColor: Colors.red));
          }
        }
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString()), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 159.0,
          height: 159.0,
          child: InkWell(
            onTap: canEditAvatar
                ? () async {
                    await pickAndUploadImage(context);
                  }
                : null,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircleImageView(
                  fit: BoxFit.cover,
                  imageUrl: imageUrl + "&token=" + userStore.user.token,
                  placeholder: const FittedBox(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(Icons.person),
                      )),
                ),
                canEditAvatar
                    ? const Positioned(
                        bottom: 10,
                        right: 10,
                        child: CircleAvatar(
                          backgroundColor: Colors.green,
                          radius: 15,
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ))
                    : Container(),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Text(
          name,
          style: const TextStyle(
              fontSize: 24.0,
              color: MoodleColors.black,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}