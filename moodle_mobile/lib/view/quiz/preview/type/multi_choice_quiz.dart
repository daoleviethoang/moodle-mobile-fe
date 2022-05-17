import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;

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
      question = questions.isNotEmpty ? questions.first.text : "";
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
            Text(
              question,
              textScaleFactor: 1.2,
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: answers
                      .map((e) => MultiChoiceTile(
                            element: e,
                          ))
                      .toList(),
                )),
          ],
        ));
  }
}

class MultiChoiceTile extends StatelessWidget {
  final dom.Element element;
  const MultiChoiceTile({Key? key, required this.element}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isCheck =
        element.querySelector("input")?.attributes.containsKey("checked") ??
            false;
    return MergeSemantics(
      child: ListTileTheme.merge(
        child: ListTile(
          title: Text(element.text),
          leading: Checkbox(
              value: isCheck,
              shape: CircleBorder(),
              activeColor: Colors.green,
              onChanged: (value) async {}),
        ),
      ),
    );
  }
}
