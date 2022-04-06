import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/constants/dimens.dart';
import 'package:flutter_html/flutter_html.dart';

class CustomTextFieldLeft extends StatelessWidget {
  const CustomTextFieldLeft({Key? key, required this.messageText})
      : super(key: key);
  final String messageText;
  @override
  Widget build(BuildContext context) {
    String messageContent = "";
    if (messageText != null) {
      messageContent = HtmlParser.parseHTML(messageText).documentElement!.text;
    }
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
          Container(
            padding: const EdgeInsets.all(Dimens.default_padding_double),
            child: Text(
              messageContent,
              style: TextStyle(fontSize: 16),
            ),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(Dimens.default_border_radius * 3),
              ),
              color: MoodleColors.brightGray,
            ),
          )
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
    String messageContent = "";
    if (messageText != null) {
      messageContent = HtmlParser.parseHTML(messageText).documentElement!.text;
    }
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
              padding: const EdgeInsets.all(Dimens.default_padding_double),
              child: Text(
                messageContent,
                style: TextStyle(fontSize: 16, color: Colors.white),
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
