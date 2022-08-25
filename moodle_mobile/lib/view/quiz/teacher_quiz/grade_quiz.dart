import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/view/common/content_item.dart';

class GradeQuiz extends StatefulWidget {
  const GradeQuiz({Key? key}) : super(key: key);

  @override
  State<GradeQuiz> createState() => _GradeQuizState();
}

class _GradeQuizState extends State<GradeQuiz> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Summary",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Text(
                  "17/30",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                      fontSize: 18),
                ),
              ],
            ),
          ),
          const LineItem(width: 1.0),
          SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 300,
              child: ListView(
                children: ListTile.divideTiles(context: context, tiles: [
                  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                          child: const Text(
                            "Question 1:",
                            textAlign: TextAlign.start,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: TextEditingController(text: "5"),
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 8.0),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                width: 1,
                              )),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                          child: const Icon(
                            Icons.check,
                            color: Color(0xff2AB930),
                          ),
                        ),
                      ],
                    ),
                    trailing: SizedBox(
                        width: 100,
                        height: 30,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Color(0xffF8DAAD),
                          ),
                          child: Center(
                            child: Text(
                              "10 points",
                              style: TextStyle(color: Color(0xffFF8A00)),
                            ),
                          ),
                        )),
                  ),
                  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                          child: const Text(
                            "Question 1:",
                            textAlign: TextAlign.start,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            enabled: false,
                            controller: TextEditingController(text: "5"),
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 8.0),
                              disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                color: MoodleColors.gray,
                                width: 1,
                              )),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                          child: const Icon(
                            Icons.check,
                            color: Color(0xff2AB930),
                          ),
                        ),
                      ],
                    ),
                    trailing: SizedBox(
                        width: 100,
                        height: 30,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Color(0xffF8DAAD),
                          ),
                          child: Center(
                            child: Text(
                              "10 points",
                              style: TextStyle(color: Color(0xffFF8A00)),
                            ),
                          ),
                        )),
                  ),
                ]).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
