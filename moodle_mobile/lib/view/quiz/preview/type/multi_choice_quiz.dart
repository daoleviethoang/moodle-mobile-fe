import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/view/common/content_item.dart';

class MultiChoiceQuiz extends StatefulWidget {
  final int uniqueId;
  final int slot;
  final String html;
  const MultiChoiceQuiz(
      {Key? key,
      required this.uniqueId,
      required this.slot,
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
              "img": (RenderContext context, Widget child) {
                final attrs = context.tree.element?.attributes;
                return Image.network(
                  (attrs?['src'] ?? "about:blank"),
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
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
                          child: MultiChoiceTile(
                            element: e,
                          )))
                      .toList(),
                )),
            Divider(),
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
    return isCheck
        ? ListTile(
            shape: const RoundedRectangleBorder(
                side: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(8))),
            contentPadding: EdgeInsets.zero,
            tileColor: MoodleColors.blue_soft,
            visualDensity: VisualDensity(horizontal: -2, vertical: -2),
            title: Text(last),
            leading: MaterialButton(
              shape: CircleBorder(
                  side: BorderSide(color: MoodleColors.blueDark, width: 2)),
              onPressed: null,
              child: Text(
                first,
                textScaleFactor: 1.1,
                style: const TextStyle(color: MoodleColors.blueDark),
              ),
            ),
          )
        : ListTile(
            shape: const RoundedRectangleBorder(
                side: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(8))),
            contentPadding: EdgeInsets.zero,
            visualDensity: VisualDensity(horizontal: -2, vertical: -2),
            title: Text(last),
            leading: MaterialButton(
              shape:
                  CircleBorder(side: BorderSide(color: Colors.black, width: 2)),
              onPressed: null,
              child: Text(
                first,
                textScaleFactor: 1.1,
              ),
            ),
          );
  }
}
