import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/colors.dart';

class StatusCommonView extends StatelessWidget {
  final String status;

  const StatusCommonView({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Icon(
            Icons.circle,
            color: MoodleColors.grey_icon_status,
            size: 10,
          ),
          Padding(
            padding: EdgeInsets.only(left: 8),
            child: Text(
              status,
              style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 13,
                  letterSpacing: 0.27,
                  color: MoodleColors.black),
            ),
          )
        ],
      ),
    );
  }
}
