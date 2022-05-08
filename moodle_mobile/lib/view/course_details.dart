import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/styles.dart';
import 'package:moodle_mobile/view/common/content_item.dart';
import 'package:moodle_mobile/view/common/image_view.dart';
import 'package:moodle_mobile/view/common/menu_item.dart';
import 'package:moodle_mobile/view/forum/forum_screen.dart';
import 'package:moodle_mobile/view/grade_in_one_course.dart';
import 'package:moodle_mobile/view/user_detail/user_detail.dart';
import 'package:moodle_mobile/view/user_detail/user_detail_student.dart';

class CourseDetailsScreen extends StatefulWidget {
  final int courseId;

  const CourseDetailsScreen({Key? key, required this.courseId})
      : super(key: key);

  @override
  _CourseDetailsScreenState createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late var _tabs = <Widget>[];
  var _index = 0;
  late var _body = <Widget>[];
  late Widget _homeTab;
  late Widget _announcementsTab;
  late Widget _discussionsTab;
  late Widget _upcomingTab;
  late Widget _gradesTab;
  late Widget _peopleTab;

  late int _courseId;

  @override
  void initState() {
    super.initState();
    _courseId = widget.courseId;
  }

  void _initBody() {
    _initTabList();
    _initHomeTab();
    _initAnnouncementsTab();
    _initDiscussionsTab();
    _initUpcomingTab();
    _initGradesTab();
    _initPeopleTab();

    _body = [
      _homeTab,
      _announcementsTab,
      _discussionsTab,
      _upcomingTab,
      _gradesTab,
      _peopleTab,
    ];
  }

  void _initTabList() {
    _tabs = [
      const Tab(child: Text('Home')),
      const Tab(child: Text('Announcements')),
      const Tab(child: Text('Discussion Forums')),
      const Tab(child: Text('Events')),
      const Tab(child: Text('Grades')),
      const Tab(child: Text('Participants')),
    ];
    _tabController = TabController(
      length: _tabs.length,
      initialIndex: _index,
      vsync: this,
    );
  }

  void _initHomeTab() {
    _homeTab = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionItem(
          header: const HeaderItem(text: 'General'),
          body: [
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
            ForumItem(
              title: 'Q&A',
              onPressed: () => {},
            ),
          ],
          hasSeparator: true,
        ),
        SectionItem(
          header: const HeaderItem(text: 'Topic 1'),
          body: [
            const DocumentItem(
              title: 'Week 1 - Getting start',
              documentUrl:
                  'https://www.ets.org/Media/Tests/GRE/pdf/gre_research_validity_data.pdf',
            ),
            const UrlItem(
              title: 'Week 1 - Getting start',
              url: 'https://docs.flutter.dev/',
            ),
            const VideoItem(
              title: 'Week 1 video',
              videoUrl:
                  'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
            ),
            SubmissionItem(
              title: 'Nộp Proposal',
              submissionId: '',
              dueDate: DateTime.utc(2022, 01, 20),
            ),
          ],
          hasSeparator: true,
        ),
        SectionItem(
          header: const HeaderItem(text: 'Topic 2'),
          body: [
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
          ],
          hasSeparator: true,
        ),
        const SectionItem(
          header: HeaderItem(text: 'Topic 3'),
          body: [
            DocumentItem(
              title: 'Week 3 - Components and Layouts',
              documentUrl: '',
            ),
          ],
        ),
      ],
    );
  }

  void _initAnnouncementsTab() {
    _announcementsTab = const Center(child: Text('Announcements'));
  }

  void _initDiscussionsTab() {
    _discussionsTab = const ForumScreen();
  }

  void _initUpcomingTab() {
    // TODO: Get event list from API
    final events = {
      'Nộp Proposal': DateTime.utc(2022, 01, 20),
      'Nộp báo cáo tuần 1': DateTime.utc(2022, 01, 27),
      'Quiz 1': DateTime.utc(2022, 01, 28),
    };
    final eventKeys = events.keys.toList();
    final eventValues = events.values.toList();

    _upcomingTab = Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Upcoming events', style: MoodleStyles.courseHeaderStyle),
          Container(height: 16),
          ...List.generate(events.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(left: 8, right: 24),
              child: SubmissionItem(
                title: eventKeys[index],
                submissionId: '',
                dueDate: eventValues[index],
              ),
            );
          }),
        ],
      ),
    );
  }

  void _initGradesTab() {
    _gradesTab = const GradeInOneCourse();
  }

  void _initPeopleTab() {
    // TODO: Get participant list from API
    final participants = [
      'Lâm Quang Vũ',
      'Nguyễn Gia Hưng',
      'Ngô Thị Thanh Theo',
      'Hà Thế Hiển',
      'Đào Lê Việt Hoàng',
      'Trần Đình Phát',
    ];

    // Return People list section
    _peopleTab = SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('People in this course',
              style: MoodleStyles.courseHeaderStyle),
          Container(height: 16),
          ...List.generate(participants.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: MenuItem(
                image: const RoundedImageView(
                  imageUrl: 'user-avatar-url',
                  placeholder: Icon(Icons.person, size: 48),
                ),
                title: participants[index],
                subtitle: 'Student',
                onPressed: () => {
                  if (index == 0)
                    {
                      Navigator.push<dynamic>(
                        context,
                        MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) => UserDetailsScreen(
                            avatar:
                                'https://meta.vn/Data/image/2021/08/17/con-vit-vang-tren-fb-la-gi-trend-anh-avatar-con-vit-vang-la-gi-3.jpg',
                            role: 'Teacher',
                            course: 'Đồ án tốt nghiệp',
                            email: 'lqvu@fit.hcmus.edu.vn',
                            location: 'TP.HCM, Vietnam',
                            name: participants[index],
                            status: 'Last online 22 hours ago',
                          ),
                        ),
                      )
                    }
                  else
                    {
                      Navigator.push<dynamic>(
                        context,
                        MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) =>
                              UserDetailStudentScreen(
                            avatar:
                                'https://meta.vn/Data/image/2021/08/17/con-vit-vang-tren-fb-la-gi-trend-anh-avatar-con-vit-vang-la-gi-3.jpg',
                            role: 'Student',
                            course: 'Đồ án tốt nghiệp',
                            email: '18127044@student.hcmus.edu.vn',
                            location: 'TP.HCM, Vietnam',
                            name: participants[index],
                            status: 'Online just now',
                          ),
                        ),
                      )
                    }
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _initBody();

    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 200,
              floating: true,
              snap: true,
              leading: TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  padding: EdgeInsets.zero,
                  shape: const CircleBorder(),
                ),
                child: const Icon(CupertinoIcons.back),
                onPressed: () => Navigator.pop(context),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: Theme.of(context).primaryColor,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 64),
                    child: SizedBox(
                      height: 120,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          'Đồ án tốt nghiệp',
                          maxLines: 2,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              bottom: TabBar(
                isScrollable: true,
                controller: _tabController,
                tabs: _tabs,
                onTap: (value) => setState(() => _index = value),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _body[_index],
              ),
              Container(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
