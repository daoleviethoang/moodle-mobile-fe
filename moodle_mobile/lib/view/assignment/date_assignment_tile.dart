import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateAssignmentTile extends StatefulWidget {
  final int date;
  final String title;
  final Color backgroundIconColor;
  final Color iconColor;
  const DateAssignmentTile({
    Key? key,
    required this.date,
    required this.title,
    this.backgroundIconColor = Colors.green,
    this.iconColor = Colors.white,
  }) : super(key: key);

  @override
  State<DateAssignmentTile> createState() => _DateAssignmentTileState();
}

class _DateAssignmentTileState extends State<DateAssignmentTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                MaterialButton(
                  shape: CircleBorder(),
                  color: widget.backgroundIconColor,
                  padding: EdgeInsets.all(20),
                  onPressed: () {},
                  child: Icon(
                    Icons.access_time,
                    size: 20,
                    color: widget.iconColor,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.title,
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                          DateFormat("hh:mmaa, dd MMMM, yyyy").format(
                              DateTime.fromMillisecondsSinceEpoch(widget.date)),
                          style: const TextStyle(
                              fontSize: 11, fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
