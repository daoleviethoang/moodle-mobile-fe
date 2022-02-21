import 'dart:html';

import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Learning Management System')),
      body: Container(
        margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.02,
            left: MediaQuery.of(context).size.width * 0.05,
            right: MediaQuery.of(context).size.width * 0.05),
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          children: [
            Row(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.circle,
                  size: 50,
                ),
                SizedBox(
                  width: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tran Dinh Phat',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '18127177@student.hcmus.edu.vn',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                )
              ],
            ),
            Divider(
              color: Colors.grey,
            ),
            Text('Settings'),
            Container(
              padding: EdgeInsets.only(left: 10),
              //color: Colors.grey,
              decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.circle_notifications_outlined,
                        size: 40,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text('App theme'),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.circle_notifications_outlined,
                        size: 40,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text('App theme'),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
