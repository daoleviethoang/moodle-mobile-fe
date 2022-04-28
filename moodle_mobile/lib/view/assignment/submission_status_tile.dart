import 'package:flutter/material.dart';

class SubmissionStatusTile extends StatefulWidget {
  final String leftText;
  final Color leftTextColor;
  final Color leftBackgroundColor;
  final String rightText;
  final Color rightTextColor;
  final Color rightBackgroundColor;

  const SubmissionStatusTile(
      {Key? key,
      required this.leftText,
      this.leftTextColor = Colors.black,
      this.leftBackgroundColor = const Color.fromARGB(255, 217, 217, 217),
      required this.rightText,
      this.rightTextColor = Colors.grey,
      this.rightBackgroundColor = Colors.white})
      : super(key: key);

  @override
  State<SubmissionStatusTile> createState() => _SubmissionStatusTileState();
}

class _SubmissionStatusTileState extends State<SubmissionStatusTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 2, right: 2, top: 5, bottom: 5),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: Colors.grey),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.only(top: 4, bottom: 4, left: 5, right: 5),
            color: widget.leftBackgroundColor,
            child: Text(
              widget.leftText,
              style: TextStyle(color: widget.leftTextColor),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 4, bottom: 4, left: 5),
            color: widget.rightBackgroundColor,
            child: Text(
              widget.rightText,
              style: TextStyle(
                fontSize: 10,
                color: widget.rightTextColor,
                overflow: TextOverflow.clip,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
