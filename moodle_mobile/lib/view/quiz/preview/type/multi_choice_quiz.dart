import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/constants/matcher.dart';
import 'package:moodle_mobile/view/common/content_item.dart';
import 'package:moodle_mobile/view/viewer/image_viewer.dart';

class MultiChoiceQuiz extends StatefulWidget {
  final int uniqueId;
  final int slot;
  final String html;
  final String token;
  const MultiChoiceQuiz(
      {Key? key,
      required this.uniqueId,
      required this.slot,
      required this.token,
      required this.html})
      : super(key: key);

  @override
  State<MultiChoiceQuiz> createState() => _MultiChoiceQuizState();
}

class _MultiChoiceQuizState extends State<MultiChoiceQuiz> {
  List<dom.Element> answers = [];
  String question = "";
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
            SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: answers
                      .map((e) => Container(
                          margin: const EdgeInsets.only(bottom: 5),
                          child: MultiChoiceTile(
                            element: e,
                          )))
                      .toList(),
                )),
            const Divider(),
          ],
        ));
  }
}

class MultiChoiceTile extends StatelessWidget {
  final dom.Element element;
  const MultiChoiceTile({Key? key, required this.element}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var list = element.text.split(".");
    var first = list.first.toUpperCase();
    list.removeAt(0);
    var last = list.join('.');
    bool isCheck =
        element.querySelector("input")?.attributes.containsKey("checked") ??
            false;
    bool isRight = element
        .getElementsByClassName("icon fa fa-check text-success fa-fw")
        .isNotEmpty;
    bool isWrong = element
        .getElementsByClassName("icon fa fa-remove text-danger fa-fw")
        .isNotEmpty;
    return isCheck
        ? ListTile(
            shape: const RoundedRectangleBorder(
                side: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(8))),
            contentPadding: EdgeInsets.zero,
            tileColor: MoodleColors.blue_soft,
            visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
            title: Text(last),
            leading: MaterialButton(
              shape: const CircleBorder(
                  side: BorderSide(color: MoodleColors.blueDark, width: 2)),
              onPressed: null,
              child: Text(
                first,
                textScaleFactor: 1.1,
                style: const TextStyle(color: MoodleColors.blueDark),
              ),
            ),
            trailing: isRight == false && isWrong == false
                ? null
                : isRight
                    ? const Icon(
                        Icons.check,
                        color: Colors.green,
                      )
                    : const Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
          )
        : ListTile(
            shape: const RoundedRectangleBorder(
                side: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(8))),
            contentPadding: EdgeInsets.zero,
            visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
            title: Text(last),
            leading: MaterialButton(
              shape:
                  const CircleBorder(side: BorderSide(color: Colors.black, width: 2)),
              onPressed: null,
              child: Text(
                first,
                textScaleFactor: 1.1,
              ),
            ),
          );
  }
}