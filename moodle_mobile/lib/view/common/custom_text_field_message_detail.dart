import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/constants/dimens.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomTextFieldLeft extends StatelessWidget {
  const CustomTextFieldLeft({Key? key, required this.messageText})
      : super(key: key);
  final String messageText;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimens.default_padding),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(right: Dimens.default_padding),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: MoodleColors.blue,
              child: Icon(
                Icons.person,
                size: 25,
                color: Colors.white,
              ),
            ),
          ),
          ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 2 / 3),
              child: Container(
                padding: const EdgeInsets.only(
                    left: Dimens.default_padding,
                    right: Dimens.default_padding),
                child: Html(
                  data: messageText,
                  onLinkTap: (url, cxt, attributes, element) async {
                    await showGeneralDialog(
                      context: context,
                      pageBuilder: (context, ani1, ani2) {
                        return AlertDialog(
                          title: Text(AppLocalizations.of(context)!.open_link),
                          content: Text(url ?? ''),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16))),
                          actions: [
                            TextButton(
                              onPressed: () async => Navigator.pop(context),
                              child: Text(AppLocalizations.of(context)!.cancel),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                await launchUrl(
                                  Uri.parse(url ?? ''),
                                  mode: LaunchMode.externalApplication,
                                );
                              },
                              child: Text(AppLocalizations.of(context)!.open),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(Dimens.default_border_radius * 3),
                  ),
                  color: MoodleColors.brightGray,
                ),
              )),
        ],
      ),
    );
  }
}

class CustomTextFieldRight extends StatelessWidget {
  const CustomTextFieldRight({Key? key, required this.messageText})
      : super(key: key);
  final String messageText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimens.default_padding),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 2 / 3),
            child: Container(
              padding: const EdgeInsets.only(
                  left: Dimens.default_padding, right: Dimens.default_padding),
              child: Html(
                data: messageText,
                onLinkTap: (url, cxt, attributes, element) async {
                  await showGeneralDialog(
                    context: context,
                    pageBuilder: (context, ani1, ani2) {
                      return AlertDialog(
                        title: Text(AppLocalizations.of(context)!.open_link),
                        content: Text(url ?? ''),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16))),
                        actions: [
                          TextButton(
                            onPressed: () async => Navigator.pop(context),
                            child: Text(AppLocalizations.of(context)!.cancel),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await launchUrl(
                                Uri.parse(url ?? ''),
                                mode: LaunchMode.externalApplication,
                              );
                            },
                            child: Text(AppLocalizations.of(context)!.open),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(Dimens.default_border_radius * 3),
                ),
                color: MoodleColors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
