import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/constants/dimens.dart';
import 'package:moodle_mobile/constants/matcher.dart';
import 'package:moodle_mobile/constants/styles.dart';
import 'package:moodle_mobile/view/common/content_item.dart';
import 'package:moodle_mobile/view/common/image_view.dart';
import 'package:moodle_mobile/view/viewer/image_viewer.dart';

class CustomCommentFieldLeft extends StatelessWidget {
  const CustomCommentFieldLeft({
    Key? key,
    required this.messageText,
    required this.senderName,
    required this.urlImage,
    required this.hourMinute,
  }) : super(key: key);
  final String messageText;
  final String senderName;
  final String hourMinute;

  final String urlImage;

  bool get noText => Bidi.stripHtmlIfNeeded(messageText).trim().isEmpty;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimens.default_padding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 1 / 7),
            child: CircleImageView(
              fit: BoxFit.cover,
              width: 25,
              height: 25,
              imageUrl: urlImage,
              placeholder: const FittedBox(
                  child: Padding(
                padding: EdgeInsets.all(5),
                child: Icon(Icons.person),
              )),
            ),
          ),
          ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 5 / 7),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        hourMinute,
                        textScaleFactor: 0.9,
                        style: TextStyle(
                          color: MoodleColors.grey,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimens.default_padding),
                    child: RichTextCard(
                        text: messageText,
                        style: MoodleStyles.leftMessageTextStyle,
                        hasPadding: noText,
                        customData: {
                          imgMatcher(): CustomRender.widget(
                              widget: (renderContext, buildChildren) {
                            final attrs =
                                renderContext.tree.element?.attributes;
                            final url = attrs?['src'] ?? '';
                            return RoundedImageView(
                              imageUrl: url,
                              width: double.infinity,
                              height: null,
                              fit: BoxFit.fitWidth,
                              placeholder:
                                  const Icon(Icons.broken_image_rounded),
                              onClick: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => ImageViewer(
                                          title: 'Image',
                                          url: url,
                                        )));
                              },
                            );
                          }),
                        }),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(Dimens.default_border_radius * 3),
                      ),
                      color: MoodleColors.brightGray,
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

class CustomCommentFieldRight extends StatelessWidget {
  const CustomCommentFieldRight({
    Key? key,
    required this.messageText,
    required this.senderName,
    required this.hourMinute,
  }) : super(key: key);
  final String messageText;
  final String senderName;
  final String hourMinute;

  bool get noText => Bidi.stripHtmlIfNeeded(messageText).trim().isEmpty;

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
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      hourMinute,
                      textScaleFactor: 0.9,
                      style: TextStyle(
                        color: MoodleColors.grey,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimens.default_padding),
                  child: Column(
                    children: [
                      RichTextCard(
                          text: messageText,
                          style: MoodleStyles.rightMessageTextStyle,
                          hasPadding: noText,
                          customData: {
                            imgMatcher(): CustomRender.widget(
                                widget: (renderContext, buildChildren) {
                              final attrs =
                                  renderContext.tree.element?.attributes;
                              final url = attrs?['src'] ?? '';
                              return RoundedImageView(
                                imageUrl: url,
                                width: double.infinity,
                                height: null,
                                fit: BoxFit.fitWidth,
                                placeholder:
                                    const Icon(Icons.broken_image_rounded),
                                onClick: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => ImageViewer(
                                            title: 'Image',
                                            url: url,
                                          )));
                                },
                              );
                            }),
                          }),
                    ],
                  ),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(Dimens.default_border_radius * 3),
                    ),
                    color: MoodleColors.blue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
