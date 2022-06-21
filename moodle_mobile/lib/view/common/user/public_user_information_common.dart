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

class PublicInformationCommonView extends StatefulWidget {
  final String imageUrl;
  final String name;
  final UserStore userStore;
  final bool canEditAvatar;

  const PublicInformationCommonView(
      {Key? key,
      required this.imageUrl,
      required this.name,
      required this.userStore,
      required this.canEditAvatar})
      : super(key: key);

  @override
  State<PublicInformationCommonView> createState() => _PublicInformationCommonViewState();
}

class _PublicInformationCommonViewState extends State<PublicInformationCommonView> {
  late String _imageUrl;
  late String _name;
  late UserStore _userStore;
  late bool _canEditAvatar;
  
  @override
  void initState() {
    super.initState();
    _imageUrl = widget.imageUrl;
    _name = widget.name;
    _userStore = widget.userStore;
    _canEditAvatar = widget.canEditAvatar;
  }
  
  Future<String?> pickAndUploadImage(BuildContext context) async {
    try {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null) {
        PlatformFile file = result.files.first;
        if (file.path != null) {
          int itemId = await FileApi()
              .uploadFile(_userStore.user.token, file.path!, null, null);
          bool check = await UserApi(DioClient(Dio()))
              .uploadAvatar(_userStore.user.token, itemId);
          if (check) {
            await _userStore.reGetUserInfo(
                _userStore.user.token, _userStore.user.username);
            SQLHelper.updateUserPhoto(UserLogin(
                token: _userStore.user.token,
                baseUrl: _userStore.user.baseUrl,
                username: _userStore.user.username,
                photo: _userStore.user.photo));
            return _userStore.user.photo;
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
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 159.0,
          height: 159.0,
          child: InkWell(
            onTap: _canEditAvatar
                ? () async {
                    final newUrl = await pickAndUploadImage(context);
                    if (newUrl != null) {
                      setState(() {
                        _imageUrl = newUrl;
                      });
                    }
                  }
                : null,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircleImageView(
                  fit: BoxFit.cover,
                  imageUrl: _imageUrl + "&token=" + _userStore.user.token,
                  placeholder: const FittedBox(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(Icons.person),
                      )),
                ),
                if (_canEditAvatar)
                  const Positioned(
                      bottom: 10,
                      right: 10,
                      child: CircleAvatar(
                        backgroundColor: Colors.green,
                        radius: 15,
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      )),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Text(
          _name,
          style: const TextStyle(
              fontSize: 24.0,
              color: MoodleColors.black,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}