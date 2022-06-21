import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/constants/styles.dart';
import 'package:moodle_mobile/models/note/note.dart';
import 'package:moodle_mobile/models/note/notes.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/common/data_card.dart';
import 'package:moodle_mobile/view/common/menu_item.dart';

class NoteList extends StatefulWidget {
  const NoteList({Key? key}) : super(key: key);

  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  Widget _folderView = Container();
  Widget _highlightView = Container();

  final _notes = Notes();

  late UserStore _userStore;
  Observable<bool>? _searchOpenFlag;

  @override
  void initState() {
    super.initState();
    _userStore = GetIt.instance<UserStore>();
  }

  void _initFolderView() {
    _folderView = GridView.builder(
      shrinkWrap: true,
      primary: false,
      padding: const EdgeInsets.only(bottom: 12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        mainAxisExtent: 128,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return [
          MenuCard(
            title: AppLocalizations.of(context)!.all_notes,
            subtitle: '${_notes.length}',
            icon: const Icon(CupertinoIcons.square_grid_2x2_fill),
            color: MoodleColors.blue,
            onPressed: () {},
          ),
          MenuCard(
            title: AppLocalizations.of(context)!.important,
            subtitle: '${_notes.important.length}',
            icon: const Icon(CupertinoIcons.star_fill),
            color: Colors.amber,
            onPressed: () {},
          ),
          MenuCard(
            title: AppLocalizations.of(context)!.done,
            subtitle: '${_notes.done.length}',
            icon: const Icon(CupertinoIcons.checkmark_seal_fill),
            color: Colors.grey,
            onPressed: () {},
          ),
          MenuCard(
            title: AppLocalizations.of(context)!.personal,
            subtitle: '${_notes.personal.length}',
            icon: const Icon(CupertinoIcons.person_alt),
            color: Colors.pink,
            onPressed: () {},
          ),
        ][index];
      },
    );
  }

  void _initHighlightView() {
    _highlightView = Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            AppLocalizations.of(context)!.recent_notes,
            style: MoodleStyles.sectionHeaderStyle,
          ),
        ),
        Container(height: 12),
        ..._notes.recent.map((n) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: NoteCard(n, onPressed: () {}),
          );
        })
      ],
    );
  }

  Future queryData() async {
    final now = DateTime.now();
    final uid = '${_userStore.user.id}';
    final d1 = '${now.millisecondsSinceEpoch}';
    final d3 =
        '${now.subtract(const Duration(days: 2)).millisecondsSinceEpoch}';
    final d5 = '${now.add(const Duration(days: 2)).millisecondsSinceEpoch}';
    final d7 =
        '${now.subtract(const Duration(days: 4)).millisecondsSinceEpoch}';
    final d6 =
        '${now.subtract(const Duration(days: 6)).millisecondsSinceEpoch}';
    final d4 =
        '${now.subtract(const Duration(days: 8)).millisecondsSinceEpoch}';
    final d2 =
        '${now.subtract(const Duration(days: 10)).millisecondsSinceEpoch}';
    _notes.replace([
      Note(
        id: '${uid}_$d1',
        courseId: null,
        title: 'Note 1',
      ),
      Note(
        id: '${uid}_$d2',
        courseId: null,
        title: 'Note 2',
        content: 'Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum',
      ),
      Note(
        id: '${uid}_$d3',
        courseId: null,
        title: null,
        content: 'Note 3 Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum',
      ),
      Note(
        id: '${uid}_$d4',
        courseId: null,
        title: 'Note 4',
        isDone: true,
      ),
      Note(
        id: '${uid}_$d5',
        courseId: null,
        title: 'Note 5',
        content: 'Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum',
        isDone: true,
      ),
      Note(
        id: '${uid}_$d6',
        courseId: null,
        title: 'Note 6',
        isImportant: true,
      ),
      Note(
        id: '${uid}_$d7',
        courseId: null,
        title: 'Note 7',
        content: 'Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum',
        isImportant: true,
      ),
      Note(
        id: '${uid}_$d1',
        courseId: null,
        title: 'Note 8',
        isDone: true,
        isImportant: true,
      ),
      Note(
        id: '${uid}_$d1',
        courseId: null,
        title: 'Note 9',
        content: 'Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum',
        isDone: true,
        isImportant: true,
      ),
    ]);

    _initFolderView();
    _initHighlightView();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: queryData(),
        builder: (context, data) {
          if (data.hasError) {
            if (kDebugMode) {
              print('${data.error}');
            }
            return ErrorCard(text: AppLocalizations.of(context)!.err_get_notes);
          }
          return RefreshIndicator(
            onRefresh: () async => setState(() {}),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        AnimatedOpacity(
                          opacity: (_notes.isEmpty) ? .5 : 1,
                          duration: const Duration(milliseconds: 300),
                          child: _folderView,
                        ),
                        AnimatedOpacity(
                          opacity: (_notes.isEmpty) ? 1 : 0,
                          duration: const Duration(milliseconds: 300),
                          child: Opacity(
                            opacity: .5,
                            child: Center(
                                child: Text(
                                    AppLocalizations.of(context)!.no_notes)),
                          ),
                        ),
                      ],
                    ),
                    if (_notes.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 12, left: 12),
                        child: _highlightView,
                      ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}