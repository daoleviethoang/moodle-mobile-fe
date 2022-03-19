import 'dart:html';

import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // int _selectedIndex = 0;

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MoodleColors.white,
        appBar: AppBar(
          backgroundColor: MoodleColors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              getPublicInfomationUI(),
              getUserDetailsUI(),
              getDescriptionUI(),
            ],
          ),
        ));
  }

  Widget getPublicInfomationUI() {
    return Container(
        child: Column(
      children: [
        Container(
          width: 159.0,
          height: 159.0,
          decoration: BoxDecoration(
            color: const Color(0xff7c94b6),
            image: const DecorationImage(
              image: NetworkImage(
                  'https://meta.vn/Data/image/2021/08/17/con-vit-vang-tren-fb-la-gi-trend-anh-avatar-con-vit-vang-la-gi-3.jpg'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.all(Radius.circular(90.0)),
            border: Border.all(
              color: MoodleColors.white,
              width: 0.0,
            ),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        const Text(
          "Nguyễn Gia Hưng",
          style: TextStyle(
              fontSize: 24.0,
              color: MoodleColors.black,
              fontWeight: FontWeight.w400),
        ),
      ],
    ));
  }

  Widget getUserDetailsUI() {
    return Container(
      margin: const EdgeInsets.only(top: 24, bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(
            left: 20.0, top: 20.0, right: 0.0, bottom: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'User details',
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                  letterSpacing: 0.27,
                  color: MoodleColors.black),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 8),
              child: Row(
                children: const <Widget>[
                  Icon(Icons.email_outlined,
                      color: MoodleColors.iconGrey, size: 24),
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text(
                      '18127044@student.hcmus.edu.vn',
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 13,
                          letterSpacing: 0.27,
                          color: MoodleColors.email),
                    ),
                  )
                ],
              ),
            ),
            Row(
              children: const <Widget>[
                Icon(
                  Icons.location_on_outlined,
                  color: MoodleColors.iconGrey,
                  size: 24,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text(
                    'TP.HCM, ' + 'Vietnam',
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 13,
                        letterSpacing: 0.27,
                        color: MoodleColors.black),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getDescriptionUI() {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(
            left: 20.0, top: 20.0, right: 20.0, bottom: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            Text(
              'Description',
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                  letterSpacing: 0.27,
                  color: MoodleColors.black),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio.',
                textAlign: TextAlign.justify,
                overflow: TextOverflow.ellipsis,
                maxLines: 10,
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    height: 1.8,
                    fontSize: 13,
                    letterSpacing: 0.0,
                    wordSpacing: 0.1,
                    color: MoodleColors.black),
              ),
            )
          ],
        ),
      ),
    );
  }
}
