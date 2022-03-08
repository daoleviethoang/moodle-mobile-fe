import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moodle_mobile/components/content_item.dart';
import 'package:moodle_mobile/components/image_view.dart';
import 'package:moodle_mobile/components/menu_item.dart';

class CourseDetailsPage extends StatefulWidget {
  final String courseId;

  const CourseDetailsPage({Key? key, required this.courseId}) : super(key: key);

  @override
  _CourseDetailsPageState createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {
  late Widget _body;
  late Widget _peopleList;
  late Widget _upcomingList;
  late Widget _contentList;

  late String _courseId;

  @override
  void initState() {
    super.initState();
    _courseId = widget.courseId;
  }

  void _initBody() {
    _initPeopleList();
    _initUpcomingList();
    _initContentList();

    _body = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        children: [
          Container(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: _peopleList,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: _upcomingList,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: _contentList,
          ),
        ],
      ),
    );
  }

  void _initPeopleList() {
    // TODO: Get participant list from API
    final participants = [
      'Lâm Quang Vũ',
      'Nguyễn Gia Hưng',
      'Ngô Thị Thanh Thảo',
      'Hà Thế Hiển',
      'Đào Lê Việt Hoàng',
      'Trần Đình Phát',
    ];

    // Generate widgets from participant list
    final widgets = <Widget>[];
    widgets
      ..addAll(List.generate(participants.length, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: CircleCaptionedImageView(
            imageUrl: 'user-avatar-url',
            placeholder: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.person, size: 48),
            ),
            caption: participants[index],
          ),
        );
      }))
      ..add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: CircleCaptionedImageView(
          imageUrl: '',
          placeholder: const Padding(
            padding: EdgeInsets.all(8),
            child: Icon(Icons.more_horiz, size: 48),
          ),
          color: Colors.grey.withOpacity(.5),
          caption: 'More',
        ),
      ));

    // Return People list section
    _peopleList = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Text('People in this course',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: widgets,
          ),
        ),
      ],
    );
  }

  void _initUpcomingList() {
    // TODO: Get event list from API
    final events = {
      'Nộp Proposal': DateTime.utc(2022, 01, 20),
      'Nộp báo cáo tuần 1': DateTime.utc(2022, 01, 27),
      'Quiz 1': DateTime.utc(2022, 01, 28),
    };

    // Generate widgets from event list
    final widgets = <Widget>[];
    final eventKeys = events.keys.toList();
    final eventValues = events.values.toList();
    widgets.addAll(List.generate(events.length, (index) {
      return Padding(
        padding: const EdgeInsets.only(left: 8, right: 24),
        child: SubmissionItem(
          title: eventKeys[index],
          submissionId: '',
          dueDate: eventValues[index],
        ),
      );
    }));

    _upcomingList = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text('Upcoming events',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: widgets,
          ),
        ),
      ],
    );
  }

  void _initContentList() {
    _contentList = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text('Course contents',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ForumItem(title: 'Announcements', onPressed: () {}),
              ForumItem(title: 'Discussion forums', onPressed: () {}),
              const RichTextCard(
                  text: "<div>"
                      "<h1>Demo Page</h1>"
                      "<p>This is a fantastic product that you should buy!</p>"
                      "<h3>Features</h3>"
                      "<ul>"
                      "<li>It actually works</li>"
                      "<li>It exists</li>"
                      "<li>It doesn't cost much!</li>"
                      "</ul>"
                      "</div>"),
              const LineItem(),
              const HeaderItem(text: 'Topic 1'),
              const DocumentItem(
                title: 'Week 1 - Getting start',
                documentUrl: '',
              ),
              const UrlItem(
                title: 'Week 1 - Getting start',
                url: 'https://docs.flutter.dev/',
              ),
              SubmissionItem(
                title: 'Nộp Proposal',
                submissionId: '',
                dueDate: DateTime.utc(2022, 01, 20),
              ),
              const LineItem(),
              const HeaderItem(text: 'Topic 2'),
              const DocumentItem(
                title: 'Week 2 - Overview React Native',
                documentUrl: '',
              ),
              const DocumentItem(
                title: 'Week 2 - Overview Flutter',
                documentUrl: '',
              ),
              SubmissionItem(
                title: 'Nộp báo cáo tuần 1',
                submissionId: '',
                dueDate: DateTime.utc(2022, 01, 27),
              ),
              QuizItem(
                title: 'Quiz 1',
                quizId: '',
                openDate: DateTime.utc(2022, 01, 28),
              ),
              const LineItem(),
              const HeaderItem(text: 'Topic 3'),
              const DocumentItem(
                title: 'Week 3 - Components and Layouts',
                documentUrl: '',
              ),
            ],
          ),
        ),
        Container(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _initBody();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Đồ án tốt nghiệp'),
        leading: TextButton(
          style: TextButton.styleFrom(
            primary: Colors.white,
            padding: EdgeInsets.zero,
            shape: const CircleBorder(),
          ),
          child: const Icon(CupertinoIcons.back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _body,
    );
  }
}