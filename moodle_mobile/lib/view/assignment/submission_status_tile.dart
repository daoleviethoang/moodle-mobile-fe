import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/colors.dart';

class SubmissionStatusTile extends StatefulWidget {
  final String leftText;
  final Color leftTextColor;
  final Color leftBackgroundColor;
  final String rightText;
  final Color rightTextColor;
  final Color rightBackgroundColor;
  final Function()? rightTap;

  const SubmissionStatusTile({
    Key? key,
    required this.leftText,
    this.leftTextColor = MoodleColors.grey_text,
    this.leftBackgroundColor = MoodleColors.submission_status_tile,
    required this.rightText,
    this.rightTextColor = Colors.grey,
    this.rightBackgroundColor = Colors.white,
    this.rightTap,
  }) : super(key: key);

  @override
  State<SubmissionStatusTile> createState() => _SubmissionStatusTileState();
}

class _SubmissionStatusTileState extends State<SubmissionStatusTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 0.5, color: Colors.grey),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Container(
            padding:
                const EdgeInsets.only(top: 4, bottom: 4, left: 5, right: 5),
            color: widget.leftBackgroundColor,
            child: Text(
              widget.leftText,
              textScaleFactor: 1.1,
              style: TextStyle(color: widget.leftTextColor),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: widget.rightTap,
              child: Container(
                padding: const EdgeInsets.only(top: 4, bottom: 4, left: 5),
                color: widget.rightBackgroundColor,
                child: Text(
                  widget.rightText,
                  style: TextStyle(
                    color: widget.rightTextColor,
                    overflow: TextOverflow.clip,
                  ),
                  textScaleFactor: 0.95,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
