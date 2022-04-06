import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:flutter_html/flutter_html.dart';
import 'package:moodle_mobile/models/assignment/assignment.dart';
import 'package:moodle_mobile/view/assignment/date_assignment_tile.dart';
import 'package:moodle_mobile/view/common/custom_button.dart';

class AssignmentScreen extends StatefulWidget {
  const AssignmentScreen({Key? key}) : super(key: key);

  @override
  _AssignmentScreenState createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  Assignment assignment = Assignment();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 5, right: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DateAssignmentTile(
                date: 0,
                title: "Opened",
                iconColor: Colors.grey,
                backgroundIconColor: Color.fromARGB(255, 217, 217, 217),
              ),
              DateAssignmentTile(
                date: 0,
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
              CustomButtonWidget(
                  textButton: "View file submission", onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
