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
          crossAxisAlignment: CrossAxisAlignment.start,
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
            SizedBox(height: 8),
            Text('Settings',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.only(left: 10, top: 10),
              //color: Colors.grey,
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.circle_notifications_outlined,
                        size: 40,
                        color: Colors.purple,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'App Theme',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Follow system',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.circle_notifications_outlined,
                        color: Colors.orange,
                        size: 40,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Notifications & sounds'),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.circle_notifications_outlined,
                        color: Colors.green,
                        size: 40,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Device permissions'),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.circle_notifications_outlined,
                        color: Colors.blue,
                        size: 40,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Moodle settings'),
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
