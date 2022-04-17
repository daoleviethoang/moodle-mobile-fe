import 'package:flutter/material.dart';
import 'package:moodle_mobile/view/common/image_view.dart';

class ForumHeader extends StatelessWidget {
  const ForumHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: CircleImageView(
            imageUrl: '',
            height: 60,
            width: 60,
            placeholder: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.person,
                size: 35,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        SizedBox(
          height: 60,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Text(
                    'Started by ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Tran Dinh Phat ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                ],
              ),
              //SizedBox(height: 20),
              Text(
                '02:00PM, 19 January, 2022',
                style: TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
