import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/view/common/content_item.dart';

class OneChoiceQuiz extends StatefulWidget {
  final int uniqueId;
  final int slot;
  final String html;
  const OneChoiceQuiz({
    Key? key,
    required this.uniqueId,
    required this.slot,
    required this.html,
  }) : super(key: key);

  @override
  State<OneChoiceQuiz> createState() => _OneChoiceQuizState();
}

class _OneChoiceQuizState extends State<OneChoiceQuiz> {
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
              "img": (RenderContext context, Widget child) {
                final attrs = context.tree.element?.attributes;
                return Image.network(
                  (attrs?['src'] ?? "about:blank"),
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                  errorBuilder: (context, error, stackTrace) =>
                      const Text("Can't load image"),
                );
              },
            }),
            Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: answers
                      .map((e) => Container(
                          margin: const EdgeInsets.only(bottom: 5),
                          child: OneChoiceTile(
                            element: e,
                          )))
                      .toList(),
                )),
            Divider(),
          ],
        ));
  }
}

class OneChoiceTile extends StatelessWidget {
  final dom.Element element;
  const OneChoiceTile({Key? key, required this.element}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var list = element.text.split(".");
    var first = list.first.toUpperCase();
    list.removeAt(0);
    var last = list.join('.');
    bool isCheck =
        element.querySelector("input")?.attributes.containsKey("checked") ??
            false;
    return isCheck
        ? ListTile(
            tileColor: MoodleColors.blue_soft,
            visualDensity: VisualDensity(horizontal: -4, vertical: -4),
            title: Text(last),
            leading: MaterialButton(
              shape: CircleBorder(
                  side: BorderSide(color: MoodleColors.blueDark, width: 1)),
              onPressed: null,
              child: Text(
                first,
                textScaleFactor: 1.1,
                style: const TextStyle(color: MoodleColors.blueDark),
              ),
            ),
          )
        : ListTile(
            visualDensity: VisualDensity(horizontal: -4, vertical: -4),
            title: Text(last),
            leading: MaterialButton(
              shape:
                  CircleBorder(side: BorderSide(color: Colors.black, width: 1)),
              onPressed: null,
              child: Text(
                first,
                textScaleFactor: 1.1,
              ),
            ),
          );
  }
}
