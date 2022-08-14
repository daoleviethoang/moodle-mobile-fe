import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/colors.dart';

class StatusCommonView extends StatelessWidget {
  final String status;
  final Color color;

  const StatusCommonView({Key? key, required this.status, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.circle,
            color: color,
            size: 12,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              status,
              style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  letterSpacing: 0.27,
                  color: MoodleColors.black),
            ),
          )
        ],
      ),
    );
  }
}
