import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;

class MultiChoiceDoQuiz extends StatefulWidget {
  final int uniqueId;
  final int slot;
  final String html;
  final int index;
  final int sequenceCheck;
  final Function(int, List<String>, List<String>) setData;
  const MultiChoiceDoQuiz(
      {Key? key,
      required this.uniqueId,
      required this.slot,
      required this.html,
      required this.index,
      required this.setData,
      required this.sequenceCheck})
      : super(key: key);

  @override
  State<MultiChoiceDoQuiz> createState() => _MultiChoiceDoQuizState();
}

class _MultiChoiceDoQuizState extends State<MultiChoiceDoQuiz> {
  List<dom.Element> answers = [];
  String question = "";
  List<String> keySave = [""];
  List<String> valueSave = [""];

  parseHtml() {
    var document = parse(widget.html);
    var questions = document.getElementsByClassName("qtext");
    List<dom.Element> elementMain = document.getElementsByClassName("answer");
    List<dom.Element> elements = elementMain.first.children;
    setState(() {
      question = questions.isNotEmpty ? questions.first.text : "";
      answers = elements;
    });

    for (var item in answers) {
      keySave.add("");
      valueSave.add("");
    }

    setState(() {
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
        setCheck(answers.indexOf(answer), isCheck, false);
      }
    }
  }

  setCheck(int index, bool value, bool saveData) {
    setState(() {
      keySave[index + 1] = "q" +
          widget.uniqueId.toString() +
          ":" +
          widget.slot.toString() +
          "_choice" +
          index.toString();
      valueSave[index + 1] = value ? "1" : "0";
    });
    if (saveData == true) {
      widget.setData(widget.index, keySave, valueSave);
    }
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
                  children: answers.map((e) {
                    int index = answers.indexOf(e);
                    return MultiChoiceTile(
                      element: e,
                      state: this,
                      isCheck: valueSave[index + 1] == "1",
                      index: index,
                    );
                  }).toList(),
                )),
          ],
        ));
  }
}

class MultiChoiceTile extends StatelessWidget {
  final dom.Element element;
  final _MultiChoiceDoQuizState state;
  final bool isCheck;
  final int index;
  const MultiChoiceTile(
      {Key? key,
      required this.element,
      required this.state,
      required this.isCheck,
      required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: VisualDensity(horizontal: -4, vertical: -4),
      title: Text(element.text),
      leading: Checkbox(
          value: isCheck,
          shape: CircleBorder(),
          activeColor: Colors.green,
          onChanged: (value) async {
            state.setCheck(index, !isCheck, true);
          }),
    );
  }
}
