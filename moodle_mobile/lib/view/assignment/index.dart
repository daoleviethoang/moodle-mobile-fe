import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:flutter_html/flutter_html.dart';
import 'package:moodle_mobile/models/assignment/assignment.dart';
import 'package:moodle_mobile/view/assignment/date_assignment_tile.dart';
import 'package:moodle_mobile/view/common/custom_button.dart';

class AssignmentScreen extends StatefulWidget {
  final int assignId;
  const AssignmentScreen({Key? key, required this.assignId}) : super(key: key);

  @override
  _AssignmentScreenState createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  Assignment assignment = Assignment();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    //getAssignmentDetail();
  }

  void getAssignmentDetail() async {
    isLoading = true;
    Assignment temp = await ReadJsonData(widget.assignId);
    setState(() {
      assignment = temp;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DateAssignmentTile(
                      date: assignment.allowsubmissionsfromdate,
                      title: "Opened",
                      iconColor: Colors.grey,
                      backgroundIconColor: Color.fromARGB(255, 217, 217, 217),
                    ),
                    DateAssignmentTile(
                      date: assignment.duedate,
                      title: "Due",
                      iconColor: Colors.green,
                      backgroundIconColor: Colors.greenAccent,
                    ),
                    Divider(),
                    Html(data: ""),
                    Text(
                      "Submission status",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    CustomButtonWidget(
                        textButton: "View file submission", onPressed: () {}),
                  ],
                ),
              ),
            ),
    );
  }
}

Future<Assignment> ReadJsonData(int id) async {
  final jsonData = await rootBundle.rootBundle
      .loadString('assets/dummy/all_assignment_course.json');
  final list = json.decode(jsonData)['courses']['assignments'] as List<dynamic>;

  print(list);

  List<Assignment> assigns = list.map((e) => Assignment.fromJson(e)).toList();
  Assignment assign = Assignment();

  for (var item in assigns) {
    if (item.cmid == id) {
      assign = item;
    }
  }

  return assign;
}
