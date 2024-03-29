import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/constants/styles.dart';
import 'package:moodle_mobile/provider/LocaleManager.dart';
import 'package:moodle_mobile/provider/StorageManager.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/common/content_item.dart';
import 'package:moodle_mobile/view/common/image_view.dart';
import 'package:moodle_mobile/view/common/language/changeLanguage.dart';
import 'package:moodle_mobile/view/common/menu_item.dart' as m;
import 'package:moodle_mobile/view/menu/account/courses_grade_overview.dart';
import 'package:moodle_mobile/view/menu/profile/profile.dart';
import 'package:moodle_mobile/view/notification_preference/index.dart';
import 'package:moodle_mobile/view/splash/splash_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late UserStore _userStore;

  String language = "default";

  @override
  void initState() {
    _userStore = GetIt.instance<UserStore>();
    super.initState();
  }

  fetchCurrentLocale() async {
    String? _locale = await StorageManager.readData('localeMode');
    setState(() {
      language = _locale ?? "default";
    });
  }

  _showChangeLanguageDialog() async {
    LocaleNotifier locale = context.read<LocaleNotifier>();
    await fetchCurrentLocale();
    final SetListLangTiles _setListTiles = SetListLangTiles(
      language: language,
    );

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.fromLTRB(50, 30, 50, 10),
          title: Text(AppLocalizations.of(context)!.choose_your_language),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _setListTiles,
              ],
            ),
          ),
          actions: [
            Row(children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
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
                width: 10,
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      language = _setListTiles.language;
                    });
                    locale.setMode(language);

                    // need change preference
                    Navigator.pop(context);
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                ProfileHeader(
                  userStore: _userStore,
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Divider(
                    height: 15,
                    thickness: 1,
                    color: MoodleColors.iconGrey,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    AppLocalizations.of(context)!.news,
                    style: MoodleStyles.sectionHeaderStyle,
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  color: Colors.grey[200],
                  margin: const EdgeInsets.only(left: 10),
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: const [
                        UrlItem(
                          title: 'Hệ thống Q&A FIT',
                          url: 'https://courses.fit.hcmus.edu.vn/q2a',
                        ),
                        SizedBox(height: 8),
                        UrlItem(
                          title: 'Đào tạo sau đại học',
                          url: 'https://www.fit.hcmus.edu.vn/vn/sdh',
                        ),
                        SizedBox(height: 8),
                        UrlItem(
                          title: 'Nghiên cứu khoa học',
                          url:
                              'https://www.fit.hcmus.edu.vn/vn/Default.aspx?tabid=1067',
                        ),
                        SizedBox(height: 8),
                        UrlItem(
                          title: 'Các chương trình theo đề án',
                          url: 'https://www.ctda.hcmus.edu.vn/',
                        ),
                        SizedBox(height: 8),
                        UrlItem(
                          title: 'Giảng dạy tại FIT.HCMUS',
                          url: 'https://teaching.fit.hcmus.edu.vn/',
                        ),
                        SizedBox(height: 8),
                        UrlItem(
                          title: 'Moodle FAQS',
                          url: 'https://courses.fit.hcmus.edu.vn/faq/',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    AppLocalizations.of(context)!.settings,
                    style: MoodleStyles.sectionHeaderStyle,
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  color: Colors.grey[200],
                  margin: const EdgeInsets.only(left: 10),
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        m.MenuItem(
                          title: AppLocalizations.of(context)!.noti_settings,
                          color: Colors.amber,
                          icon: const Icon(Icons.notifications_rounded),
                          fullWidth: true,
                          context: context,
                          onPressed: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (_) {
                              return const NotificationPreferenceScreen();
                            }));
                          },
                        ),
                        const SizedBox(height: 8),
                        // m.MenuItem(
                        //   title: AppLocalizations.of(context)!.moodle_settings,
                        //   color: Colors.blueGrey,
                        //   icon: const Icon(Icons.school_rounded),
                        //   fullWidth: true,
                        //   onPressed: () {},
                        // ),
                        // const SizedBox(height: 8),
                        m.MenuItem(
                          title: AppLocalizations.of(context)!.app_language,
                          color: Colors.purple.shade200,
                          icon: const Icon(Icons.lightbulb_rounded),
                          fullWidth: true,
                          context: context,
                          onPressed: () async {
                            await _showChangeLanguageDialog();
                          },
                        ),
                        const SizedBox(height: 8),
                        m.MenuItem(
                          title: AppLocalizations.of(context)!.permissions,
                          color: Colors.green,
                          icon: const Icon(Icons.lock_rounded),
                          fullWidth: true,
                          context: context,
                          onPressed: () async {
                            await AppSettings.openAppSettings();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    AppLocalizations.of(context)!.account,
                    style: MoodleStyles.sectionHeaderStyle,
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  color: Colors.grey[200],
                  margin: const EdgeInsets.only(left: 10),
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // m.MenuItem(
                        //   title: AppLocalizations.of(context)!.change_password,
                        //   color: MoodleColors.blue,
                        //   icon: const Icon(Icons.password_rounded),
                        //   fullWidth: true,
                        //   onPressed: () {},
                        // ),
                        // const SizedBox(height: 8),
                        m.MenuItem(
                          title: AppLocalizations.of(context)!.grades,
                          color: Colors.amber,
                          icon: const Icon(Icons.grade),
                          fullWidth: true,
                          context: context,
                          onPressed: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (_) {
                              return const CoursesGradeOverviewScreen();
                            }));
                          },
                        ),
                        m.MenuItem(
                          title: AppLocalizations.of(context)!.report,
                          color: Colors.red,
                          icon: const Icon(Icons.campaign_rounded),
                          fullWidth: true,
                          context: context,
                          onPressed: () => launchUrl(Uri.parse(
                              'mailto:prj.covid@fit.hcmus.edu.vn'
                              '?cc=18127044@student.hcmus.edu.vn,'
                              '18127053@student.hcmus.edu.vn,'
                              '18127097@student.hcmus.edu.vn,'
                              '18127101@student.hcmus.edu.vn,'
                              '18127177@student.hcmus.edu.vn'
                              '&subject=${AppLocalizations.of(context)!.mail_subject}')),
                        ),
                        const SizedBox(height: 8),
                        m.MenuItem(
                          title: AppLocalizations.of(context)!.logout,
                          color: Colors.grey,
                          icon: const Icon(Icons.logout_rounded),
                          fullWidth: true,
                          context: context,
                          onPressed: () async {
                            _userStore.logout();
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (_) {
                              return const SplashScreen();
                            }));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({
    Key? key,
    required UserStore userStore,
  })  : _userStore = userStore,
        super(key: key);

  final UserStore _userStore;

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  late UserStore _userStore;

  @override
  initState() {
    super.initState();
    _userStore = widget._userStore;
  }

  @override
  Widget build(BuildContext context) {
    var avatar = "";
    if (_userStore.user.photo!.contains("?")) {
      avatar = _userStore.user.photo! + "&token=" + _userStore.user.token;
    } else {
      avatar = _userStore.user.photo! + "?token=" + _userStore.user.token;
    }
    return InkWell(
      onTap: () => Navigator.push<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => ProfileScreen(
            userStore: _userStore,
          ),
        ),
      ).then((value) {
        setState(() {});
      }),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleImageView(
                fit: BoxFit.none,
                imageUrl: avatar,
                placeholder: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.person,
                    size: 32,
                    color: Colors.white,
                  ),
                )),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  _userStore.user.fullname,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _userStore.user.email,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData iconName;
  final String name;
  final Color iconColor;

  const MenuButton({
    Key? key,
    required this.onTap,
    required this.name,
    required this.iconName,
    required this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: iconColor,
            child: Icon(
              iconName,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            name,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
