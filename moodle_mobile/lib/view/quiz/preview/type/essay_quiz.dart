import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/constants/matcher.dart';
import 'package:moodle_mobile/view/common/content_item.dart';
import 'package:moodle_mobile/view/common/custom_text_field.dart';
import 'package:moodle_mobile/view/viewer/image_viewer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EssayQuiz extends StatefulWidget {
  final int uniqueId;
  final int slot;
  final String html;
  final String token;
  const EssayQuiz({
    Key? key,
    required this.uniqueId,
    required this.slot,
    required this.html,
    required this.token,
  }) : super(key: key);

  @override
  State<EssayQuiz> createState() => _EssayQuizState();
}

class _EssayQuizState extends State<EssayQuiz> {
  List<dom.Element> answers = [];
  String question = "";
  dom.Element? image;
  parseHtml() {
    var document = parse(widget.html);
    var questions = document.getElementsByClassName("qtext");
    List<dom.Element> elementMain = document.getElementsByClassName("answer");
    List<dom.Element> elements = elementMain.first.children;
    setState(() {
      question = questions.isNotEmpty
          ? questions.first.innerHtml.replaceAll("\n", "").replaceAll("\r", "")
          : "";
      answers = elements;
    });
  }

  @override
  void initState() {
    parseHtml();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichTextCard(text: question, style: {
              'p': Style(fontSize: const FontSize(16)),
            }, customData: {
              imgMatcher():
                  CustomRender.widget(widget: (renderContext, buildChildren) {
                final attrs = renderContext.tree.element?.attributes;
                final src = (attrs?['src'] ?? "about:blank").replaceAll(
                        "pluginfile.php", "webservice/pluginfile.php") +
                    "?token=" +
                    widget.token;
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => ImageViewer(
                              title: 'Image',
                              url: src,
                            )));
                  },
                  child: Image.network(
                    src,
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                    errorBuilder: (context, error, stackTrace) =>
                        const Text("Can't load image"),
                  ),
                );
              }),
            }),
            Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      child: EssayTile(
                        element: answers[1],
                      ),
                    ),
                  ],
                )),
            Divider(),
          ],
        ));
  }
}

class EssayTile extends StatelessWidget {
  final dom.Element element;
  const EssayTile({Key? key, required this.element}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTextFieldWidget(
        hintText: AppLocalizations.of(context)!.answer,
        readonly: true,
        haveLabel: true,
        maxLines: null,
        controller: TextEditingController(text: element.text),
        borderRadius: 0.2);
  }
}
