import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;
import 'package:moodle_mobile/constants/colors.dart';

class OneChoiceDoQuiz extends StatefulWidget {
  final int uniqueId;
  final int slot;
  final String html;
  final int index;
  final int sequenceCheck;
  final Function(int, bool) setComplete;
  final Function(int, List<String>, List<String>) setData;
  const OneChoiceDoQuiz({
    Key? key,
    required this.uniqueId,
    required this.slot,
    required this.html,
    required this.index,
    required this.setData,
    required this.sequenceCheck,
    required this.setComplete,
  }) : super(key: key);

  @override
  State<OneChoiceDoQuiz> createState() => _OneChoiceDoQuizState();
}

class _OneChoiceDoQuizState extends State<OneChoiceDoQuiz> {
  List<dom.Element> answers = [];
  String question = "";
  List<String> keySave = ["", ""];
  List<String> valueSave = ["", ""];
  int indexChoose = -1;
  int sequenceCheck = 0;

  parseHtml() {
    var document = parse(widget.html);
    var questions = document.getElementsByClassName("qtext");
    List<dom.Element> elementMain = document.getElementsByClassName("answer");
    List<dom.Element> elements = elementMain.first.children;
    setState(() {
      question = questions.isNotEmpty ? questions.first.text : "";
      answers = elements;
    });
    for (var answer in answers) {
      bool isCheck =
          answer.querySelector("input")?.attributes.containsKey("checked") ??
              false;
      if (isCheck == true) {
        setState(() {
          indexChoose = answers.indexOf(answer);
        });
        widget.setComplete(widget.index, true);
      }
    }
  }

  @override
  void initState() {
    parseHtml();
    sequenceCheck = widget.sequenceCheck;
    super.initState();
  }

  setCheck(int index) async {
    setState(() {
      sequenceCheck++;
      indexChoose = index;
      keySave[0] = "q" +
          widget.uniqueId.toString() +
          ":" +
          widget.slot.toString() +
          "_:sequencecheck";
      valueSave[0] = (widget.sequenceCheck).toString();
      keySave[1] = "q" +
          widget.uniqueId.toString() +
          ":" +
          widget.slot.toString() +
          "_answer";
      valueSave[1] = index.toString();
    });
    await widget.setData(widget.index, keySave, valueSave);
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
              textScaleFactor: 1.3,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Select one:",
              textScaleFactor: 1.1,
            ),
            SizedBox(
              height: 5,
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: answers.map((e) {
                    int index = answers.indexOf(e);
                    return Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        child: OneChoiceTile(
                          element: e,
                          state: this,
                          isCheck: indexChoose == index,
                          index: index,
                        ));
                  }).toList(),
                )),
            Divider(),
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
    var list = element.text.split(".");
    var first = list.first.toUpperCase();
    var last = list.last;
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
              onPressed: () {
                state.setCheck(index);
              },
              child: Text(
                first,
                textScaleFactor: 1.1,
              ),
            ),
          );
  }
}
