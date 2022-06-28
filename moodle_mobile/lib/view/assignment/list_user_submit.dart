import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moodle_mobile/models/assignment/user_submited.dart';

class ListUserSubmited extends StatelessWidget {
  final List<UserSubmited> userSubmiteds;
  final String title;
  const ListUserSubmited({
    Key? key,
    required this.userSubmiteds,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            snap: true,
            title: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
              overflow: TextOverflow.clip,
            ),
            leading: TextButton(
              style: TextButton.styleFrom(
                primary: Colors.white,
              ),
              child: const Icon(CupertinoIcons.back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
        body: SingleChildScrollView(
          child: Column(
              children: userSubmiteds
                  .map(
                    (e) => ListTile(
                      title: Text(
                        e.fullname ?? "",
                      ),
                      trailing: Checkbox(
                        value: e.submitted,
                        shape: const CircleBorder(),
                        activeColor: Colors.green,
                        onChanged: (value) {},
                      ),
                    ),
                  )
                  .toList()),
        ),
      ),
    );
  }
}
