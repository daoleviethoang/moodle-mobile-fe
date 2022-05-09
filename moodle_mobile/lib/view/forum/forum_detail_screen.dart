import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:moodle_mobile/view/common/content_item.dart';

class ForumDetailScreen extends StatelessWidget {
  const ForumDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('How to use widget in flutter')),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child:
                        AttachmentItem(title: 'Example.zip', attachmentUrl: ''),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: AttachmentItem(
                        title: '18127044.pdf', attachmentUrl: ''),
                  ),
                ],
              ),
            ),
            Html(
              data: "<div>"
                  "<h1>Demo Page</h1>"
                  "<p>This is a fantastic product that you should buy!</p>"
                  "<h3>Features</h3>"
                  "<ul>"
                  "<li>It actually works</li>"
                  "<li>It exists</li>"
                  "<li>It doesn't cost much!</li>"
                  "</ul>"
                  "</div>",
              style: {
                'h1': Style(fontSize: const FontSize(19)),
                'h2': Style(fontSize: const FontSize(17.5)),
                'h3': Style(fontSize: const FontSize(16)),
              },
            ),
            Divider(),
            ReplyCard()
          ],
        ),
      ),
    );
  }
}

class ReplyCard extends StatelessWidget {
  const ReplyCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Re: How to use Widges in Flutter',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  Text('by '),
                  Text(
                    'Ngô Thị Thanh Thảo',
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '(04:30PM, 19 January, 2022)',
                style: TextStyle(color: Colors.grey, fontSize: 10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium.'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(Icons.message),
                  SizedBox(
                    width: 5,
                  ),
                  Text('Reply'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
