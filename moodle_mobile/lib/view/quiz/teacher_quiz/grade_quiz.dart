import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:moodle_mobile/constants/colors.dart';

class GradeQuiz extends StatefulWidget {
  const GradeQuiz({Key? key}) : super(key: key);

  @override
  State<GradeQuiz> createState() => _GradeQuizState();
}

class _GradeQuizState extends State<GradeQuiz> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Summary",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
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
          SizedBox(
            height: MediaQuery.of(context).size.height - 100,
            child: ListView(
              children: ListTile.divideTiles(context: context, tiles: [
                ListTile(
                  leading: Text("Question 1:"),
                  title: SizedBox(
                    width: 100,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Expanded(
                            child: TextField(
                                decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 10.0),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                      width: 2,
                                    )),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                      width: 2,
                                    ))))),
                        SizedBox(
                          width: 25.0,
                        )
                      ],
                    ),
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
                  leading: Text("Question 2:"),
                  title: SizedBox(
                    width: 100,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                            child: TextField(
                                controller: TextEditingController(text: "5"),
                                enabled: false,
                                style: TextStyle(color: MoodleColors.gray),
                                decoration: const InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 10.0),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                      width: 2,
                                    )),
                                    disabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: MoodleColors.gray)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                      width: 2,
                                    ))))),
                        const Icon(
                          Icons.check,
                          color: Color(0xff2AB930),
                        )
                      ],
                    ),
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
          )
        ],
      ),
    );
  }
}
