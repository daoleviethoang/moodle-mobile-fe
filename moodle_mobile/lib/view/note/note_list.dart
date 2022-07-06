import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/constants/styles.dart';
import 'package:moodle_mobile/data/network/apis/notes/notes_service.dart';
import 'package:moodle_mobile/models/note/note.dart';
import 'package:moodle_mobile/models/note/notes.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/common/custom_text_field.dart';
import 'package:moodle_mobile/view/common/data_card.dart';
import 'package:moodle_mobile/view/common/menu_item.dart';

import 'note_edit_dialog.dart';
import 'note_folder.dart';

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

  // region Init widgets

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
            onPressed: () => Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => NoteFolder(
                  notes: _notes,
                  type: NoteFolderType.all,
              token: _userStore.user.token,
              onCheckbox: (value, note) async =>
                  await NotesService().toggleDone(_userStore.user.token, note),
              onPressed: (note) => _openNoteDialog(context, note),
                ),
              ),
            ),
          ),
          MenuCard(
            title: AppLocalizations.of(context)!.important,
            subtitle: '${_notes.important.length}',
            icon: const Icon(CupertinoIcons.star_fill),
            color: Colors.amber,
            onPressed: () => Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => NoteFolder(
                  notes: _notes,
                  type: NoteFolderType.important,
              token: _userStore.user.token,
              onCheckbox: (value, note) async =>
                  await NotesService().toggleDone(_userStore.user.token, note),
              onPressed: (note) => _openNoteDialog(context, note),
                ),
              ),
            ),
          ),
          MenuCard(
            title: AppLocalizations.of(context)!.done,
            subtitle: '${_notes.done.length}',
            icon: const Icon(CupertinoIcons.checkmark_seal_fill),
            color: Colors.grey,
            onPressed: () => Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => NoteFolder(
                  notes: _notes,
                  type: NoteFolderType.done,
              token: _userStore.user.token,
              onCheckbox: (value, note) async =>
                  await NotesService().toggleDone(_userStore.user.token, note),
              onPressed: (note) => _openNoteDialog(context, note),
                ),
              ),
            ),
          ),
          MenuCard(
            title: AppLocalizations.of(context)!.other,
            subtitle: '${_notes.other.length}',
            icon: const Icon(CupertinoIcons.doc_on_doc_fill),
            color: Colors.pink,
            onPressed: () => Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => NoteFolder(
                  notes: _notes,
                  type: NoteFolderType.other,
              token: _userStore.user.token,
              onCheckbox: (value, note) async =>
                  await NotesService().toggleDone(_userStore.user.token, note),
              onPressed: (note) => _openNoteDialog(context, note),
                ),
              ),
            ),
          ),
        ][index];
      },
    );
  }

  void _initHighlightView() {
    _highlightView = Column(
      children: [
        Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppLocalizations.of(context)!.recent_notes,
                style: MoodleStyles.sectionHeaderStyle,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: InkWell(
                onTap: () => Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => NoteFolder(
                      notes: _notes,
                      type: NoteFolderType.recent,
              token: _userStore.user.token,
              onCheckbox: (value, note) async =>
                  await NotesService().toggleDone(_userStore.user.token, note),
              onPressed: (note) => _openNoteDialog(context, note),
                    ),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.see_all,
                  style: MoodleStyles.noteSeeAllStyle,
                ),
              ),
            ),
          ],
        ),
        Container(height: 12),
        if (_notes.recent.isEmpty)
          Center(
            child: Text(
              AppLocalizations.of(context)!.no_notes,
            ),
          ),
        ..._notes.recent.map((n) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: NoteCard(
              n,
              _userStore.user.token,
              onCheckbox: (value) async =>
                  await NotesService().toggleDone(_userStore.user.token, n),
              onPressed: () => _openNoteDialog(context, n),
            ),
          );
        })
      ],
    );
  }

  // endregion

  void _openNoteDialog(BuildContext context, [Note? n]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => NoteEditDialog(
        token: _userStore.user.token,
        uid: _userStore.user.id,
        cid: null,
        note: n,
      ),
    ).then((result) {
      if (result.runtimeType is Note) queryData();
    });
  }

  Future queryData() async {
    _notes.replace(
        fromNotes: await NotesService()
            .getNotes(_userStore.user.token, _userStore.user.id));
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
                    Container(height: 6),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: NoteAddTextField(
                        onTap: () => _openNoteDialog(context),
                      ),
                    ),
                    Container(height: 6),
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