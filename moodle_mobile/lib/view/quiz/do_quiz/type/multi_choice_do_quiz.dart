import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/constants/matcher.dart';
import 'package:moodle_mobile/view/common/content_item.dart';
import 'package:moodle_mobile/view/viewer/image_viewer.dart';

class MultiChoiceDoQuiz extends StatefulWidget {
  final int uniqueId;
  final int slot;
  final String token;
  final String html;
  final int index;
  final int sequenceCheck;
  final Function(int, bool) setComplete;
  final Function(int, List<String>, List<String>) setData;
  const MultiChoiceDoQuiz({
    Key? key,
    required this.uniqueId,
    required this.slot,
    required this.html,
    required this.index,
    required this.setData,
    required this.sequenceCheck,
    required this.setComplete,
    required this.token,
  }) : super(key: key);

  @override
  State<MultiChoiceDoQuiz> createState() => _MultiChoiceDoQuizState();
}

class _MultiChoiceDoQuizState extends State<MultiChoiceDoQuiz> {
  List<dom.Element> answers = [];
  String question = "";
  List<String> keySave = [""];
  List<String> valueSave = [""];
  List<bool> check = [];
  int sequenceCheck = 0;

  parseHtml() {
    var document = parse(widget.html);
    var questions = document.getElementsByClassName("qtext");
    List<dom.Element> elementMain = document.getElementsByClassName("answer");
    List<dom.Element> elements = elementMain.first.children;
    setState(() {
      question = questions.isNotEmpty ? questions.first.innerHtml : "";
      answers = elements;
    });

    for (var _ in answers) {
      keySave.add("");
      valueSave.add("");
    }

    for (var answer in answers) {
      var inputs = answer.querySelectorAll("input");
      for (var input in inputs) {
        bool isCheck = input.attributes.containsKey("checked");
        if (isCheck == true) {
          setCheck(answers.indexOf(answer), true, false);
          widget.setComplete(widget.index, true);
        }
        setState(() {
          check.add(isCheck);
        });
      }
    }
  }

  setCheck(int index, bool value, bool saveData) async {
    setState(() {
      keySave[0] = "q" +
          widget.uniqueId.toString() +
          ":" +
          widget.slot.toString() +
          "_:sequencecheck";
      valueSave[0] = (sequenceCheck).toString();
      keySave[index + 1] = "q" +
          widget.uniqueId.toString() +
          ":" +
          widget.slot.toString() +
          "_choice" +
          index.toString();
      valueSave[index + 1] = value ? "1" : "0";
    });
    if (saveData == true) {
      bool check2 = await widget.setData(widget.index, keySave, valueSave);
      if (check2 == true) {
        setState(() {
          sequenceCheck++;
          check[index] = value;
        });
      }
      if (check.where((e) => e == true).isNotEmpty) {
        widget.setComplete(widget.index, true);
      } else {
        widget.setComplete(widget.index, false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      sequenceCheck = widget.sequenceCheck;
    });
    parseHtml();
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
            const SizedBox(height: 15),
            const Text(
              "Select one or more:",
              textScaleFactor: 1.1,
            ),
            const SizedBox(height: 5),
            SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: answers.map((e) {
                    int index = answers.indexOf(e);
                    return Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        child: MultiChoiceTile(
                          element: e,
                          state: this,
                          isCheck: check[index],
                          index: index,
                        ));
                  }).toList(),
                )),
            const Divider(),
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
    var list = element.text.split(".");
    var first = list.first.toUpperCase();
    list.removeAt(0);
    var last = list.join('.');
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
              onPressed: () async {
                await state.setCheck(index, !isCheck, true);
              },
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
            visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
            title: Text(last),
            leading: MaterialButton(
              shape:
                  const CircleBorder(side: BorderSide(color: Colors.black, width: 2)),
              onPressed: () async {
                await state.setCheck(index, !isCheck, true);
              },
              child: Text(
                first,
                textScaleFactor: 1.1,
              ),
            ),
          );
  }
}