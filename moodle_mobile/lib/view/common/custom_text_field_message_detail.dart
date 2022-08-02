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

class CustomTextFieldLeft extends StatelessWidget {
  const CustomTextFieldLeft({Key? key, required this.messageText})
      : super(key: key);
  final String messageText;

  bool get noText => Bidi.stripHtmlIfNeeded(messageText).trim().isEmpty;

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
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimens.default_padding),
                child: RichTextCard(
                    text: messageText,
                    style: MoodleStyles.leftMessageTextStyle,
                    hasPadding: noText,
                    customData: {
                      imgMatcher(): CustomRender.widget(
                          widget: (renderContext, buildChildren) {
                        final attrs = renderContext.tree.element?.attributes;
                        final url = attrs?['src'] ?? '';
                        return RoundedImageView(
                          imageUrl: url,
                          width: double.infinity,
                          height: null,
                          fit: BoxFit.fitWidth,
                          placeholder: const Icon(Icons.broken_image_rounded),
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
              child: RichTextCard(
                  text: messageText,
                  style: MoodleStyles.rightMessageTextStyle,
                  hasPadding: noText,
                  customData: {
                    imgMatcher(): CustomRender.widget(
                        widget: (renderContext, buildChildren) {
                      final attrs = renderContext.tree.element?.attributes;
                      final url = attrs?['src'] ?? '';
                      return RoundedImageView(
                        imageUrl: url,
                        width: double.infinity,
                        height: null,
                        fit: BoxFit.fitWidth,
                        placeholder: const Icon(Icons.broken_image_rounded),
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
                color: MoodleColors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}