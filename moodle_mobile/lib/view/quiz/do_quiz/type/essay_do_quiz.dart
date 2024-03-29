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

class EssayDoQuiz extends StatefulWidget {
  final int uniqueId;
  final int slot;
  final String html;
  final String token;
  final int index;
  final int sequenceCheck;
  final Function(int, bool) setComplete;
  final Function(int, List<String>, List<String>) setData;
  const EssayDoQuiz({
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
  State<EssayDoQuiz> createState() => _EssayDoQuizState();
}

class _EssayDoQuizState extends State<EssayDoQuiz> {
  List<dom.Element> answers = [];
  String question = "";
  List<String> keySave = ["", ""];
  List<String> valueSave = ["", ""];
  int sequenceCheck = 0;
  TextEditingController controller = TextEditingController();

  parseHtml() {
    var document = parse(widget.html);
    var questions = document.getElementsByClassName("qtext");
    List<dom.Element> elementMain = document.getElementsByClassName("answer");
    List<dom.Element> elements = elementMain.first.children;
    setState(() {
      question = questions.isNotEmpty ? questions.first.innerHtml : "";
      answers = elements;
    });
    if (answers.length > 1 &&
        answers[1].text != null &&
        answers[1].text != "") {
      widget.setComplete(widget.index, true);
      setState(() {
        controller = TextEditingController(text: answers[1].text);
      });
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

  saveQuiz() async {
    setState(() {
      keySave[0] = "q" +
          widget.uniqueId.toString() +
          ":" +
          widget.slot.toString() +
          "_:sequencecheck";
      valueSave[0] = (sequenceCheck).toString();
      keySave[1] = "q" +
          widget.uniqueId.toString() +
          ":" +
          widget.slot.toString() +
          "_answer";
      valueSave[1] = controller.text;
    });

    bool check2 = await widget.setData(widget.index, keySave, valueSave);
    if (check2 == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.saved),
          backgroundColor: Colors.green));
      setState(() {
        sequenceCheck++;
      });
    }

    widget.setComplete(widget.index, true);
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
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      child: EssayDoTile(
                        element: answers[1],
                        state: this,
                        controller: controller,
                      ),
                    ),
                  ],
                )),
            const Divider(),
          ],
        ));
  }
}

class EssayDoTile extends StatelessWidget {
  final dom.Element element;
  final _EssayDoQuizState state;
  final TextEditingController controller;
  const EssayDoTile({
    Key? key,
    required this.element,
    required this.state,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
      title: CustomTextFieldWidget(
          hintText: AppLocalizations.of(context)!.answer,
          haveLabel: true,
          controller: controller,
          maxLines: null,
          onSubmited: (text) {
            state.saveQuiz();
          },
          borderRadius: 0.2),
      trailing: IconButton(
        onPressed: () {
          state.saveQuiz();
        },
        icon: const Icon(
          Icons.save,
          color: MoodleColors.blue,
        ),
      ),
    );
  }
}
