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
  }) : super(key: key);
  final String messageText;
  final String senderName;
  final String urlImage;

  bool get noText => Bidi.stripHtmlIfNeeded(messageText).trim().isEmpty;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimens.default_padding),
      child: Row(
        children: [
          ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 2 / 3),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimens.default_padding),
                child: Column(
                  children: [
                    Text(
                      senderName,
                      style: const TextStyle(color: MoodleColors.blue),
                    ),
                    Row(
                      children: [
                        CircleImageView(
                          fit: BoxFit.cover,
                          imageUrl: urlImage,
                          placeholder: const FittedBox(
                              child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(Icons.person),
                          )),
                        ),
                        RichTextCard(
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
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
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
                  ],
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

class CustomCommentFieldRight extends StatelessWidget {
  const CustomCommentFieldRight({
    Key? key,
    required this.messageText,
    required this.senderName,
    required this.urlImage,
  }) : super(key: key);
  final String messageText;
  final String senderName;
  final String urlImage;

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
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimens.default_padding),
              child: Column(
                children: [
                  Text(
                    senderName,
                    style: const TextStyle(color: MoodleColors.blue),
                  ),
                  Row(
                    children: [
                      CircleImageView(
                        fit: BoxFit.cover,
                        imageUrl: urlImage,
                        placeholder: const FittedBox(
                            child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(Icons.person),
                        )),
                      ),
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
                ],
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
