import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;

class OneChoiceDoQuiz extends StatefulWidget {
  final int uniqueId;
  final int slot;
  final String html;
  final int index;
  final int sequenceCheck;
  final Function(int, List<String>, List<String>) setData;
  const OneChoiceDoQuiz(
      {Key? key,
      required this.uniqueId,
      required this.slot,
      required this.html,
      required this.index,
      required this.setData,
      required this.sequenceCheck})
      : super(key: key);

  @override
  State<OneChoiceDoQuiz> createState() => _OneChoiceDoQuizState();
}

class _OneChoiceDoQuizState extends State<OneChoiceDoQuiz> {
  List<dom.Element> answers = [];
  String question = "";
  List<String> keySave = ["", ""];
  List<String> valueSave = ["", ""];
  int indexChoose = 0;

  parseHtml() {
    var document = parse(widget.html);
    var questions = document.getElementsByClassName("qtext");
    List<dom.Element> elementMain = document.getElementsByClassName("answer");
    List<dom.Element> elements = elementMain.first.children;
    setState(() {
      question = questions.isNotEmpty ? questions.first.text : "";
      answers = elements;
      keySave[0] = "q" +
          widget.uniqueId.toString() +
          ":" +
          widget.slot.toString() +
          "_:sequencecheck";
      valueSave[0] = (widget.sequenceCheck + 1).toString();
    });
    for (var answer in answers) {
      bool isCheck =
          answer.querySelector("input")?.attributes.containsKey("checked") ??
              false;
      if (isCheck == true) {
        setCheck(answers.indexOf(answer));
      }
    }
  }

  @override
  void initState() {
    parseHtml();
    super.initState();
  }

  setCheck(int index) {
    setState(() {
      indexChoose = index;
      keySave[1] = "q" +
          widget.uniqueId.toString() +
          ":" +
          widget.slot.toString() +
          "_answer";
      valueSave[1] = index.toString();
    });
    widget.setData(widget.index, keySave, valueSave);
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
                  children: answers.map((e) {
                    int index = answers.indexOf(e);
                    return OneChoiceTile(
                      element: e,
                      state: this,
                      isCheck: indexChoose == index,
                      index: index,
                    );
                  }).toList(),
                )),
          ],
        ));
  }
}

class OneChoiceTile extends StatelessWidget {
  final dom.Element element;
  final _OneChoiceDoQuizState state;
  final bool isCheck;
  final int index;
  const OneChoiceTile(
      {Key? key,
      required this.element,
      required this.state,
      required this.isCheck,
      required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: ListTileTheme.merge(
        child: ListTile(
          title: Text(element.text),
          leading: Checkbox(
              value: isCheck,
              shape: CircleBorder(),
              activeColor: Colors.green,
              onChanged: (value) async {
                state.setCheck(index);
              }),
        ),
      ),
    );
  }
}
