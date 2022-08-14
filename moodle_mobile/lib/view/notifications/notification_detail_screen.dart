import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moodle_mobile/view/common/content_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationDetailScreen extends StatelessWidget {
  final String? content;
  final String? article;
  final int? type;
  final String? subject;
  const NotificationDetailScreen(
      {Key? key, this.article, this.content, this.subject, this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            snap: true,
            title: Text(
              article ?? "",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
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
            children: [
              Container(
                margin: const EdgeInsets.only(left: 8, right: 8),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Card(
                      elevation: 10,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                              left: 15,
                              top: 20,
                              right: 15,
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.subject,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 15,
                              top: 10,
                              right: 15,
                              bottom: 10,
                            ),
                            child: TextField(
                              readOnly: true,
                              maxLines: 1,
                              controller: null,
                              decoration: InputDecoration(
                                hintText: subject ?? " ",
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 1.0, horizontal: 10.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(width: 1),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Card(
                      elevation: 10,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                              left: 15,
                              top: 20,
                              right: 15,
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.content,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 15,
                              top: 10,
                              right: 15,
                              bottom: 10,
                            ),
                            child: Container(
                                decoration: BoxDecoration(
                                    //color: MoodleColors.blue,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey)),
                                child: RichTextCard(text: content)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
