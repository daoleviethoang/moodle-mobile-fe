import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class UserDetailCommonView extends StatelessWidget {
  final String email;
  final String location;

  const UserDetailCommonView(
      {Key? key, required this.email, required this.location})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(
            left: 20.0, top: 20.0, right: 0.0, bottom: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              AppLocalizations.of(context)!.user_details,
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                  letterSpacing: 0.27,
                  color: MoodleColors.black),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 8),
              child: Row(
                children: <Widget>[
                  const Icon(Icons.email_outlined,
                      color: MoodleColors.iconGrey, size: 24),
                  InkWell(
                    onTap: () => launchUrl(
                      Uri.parse('mailto:$email'),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Text(
                        email,
                        style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            letterSpacing: 0.27,
                            color: MoodleColors.text_blue),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                const Icon(
                  Icons.location_on_outlined,
                  color: MoodleColors.iconGrey,
                  size: 24,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text(
                    location,
                    style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        letterSpacing: 0.27,
                        color: MoodleColors.black),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
