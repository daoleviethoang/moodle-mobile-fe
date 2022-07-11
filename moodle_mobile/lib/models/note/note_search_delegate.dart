import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/data/network/apis/notes/notes_service.dart';
import 'package:moodle_mobile/models/note/note.dart';
import 'package:moodle_mobile/view/common/data_card.dart';
import 'package:moodle_mobile/view/note/note_edit_dialog.dart';

class NoteSearchDelegate extends SearchDelegate<String> {
  final BuildContext context;
  final List<Note> notes;
  final String token;
  final String hint;

  NoteSearchDelegate(this.context, this.notes, this.token, {this.hint = ''});

  @override
  String get searchFieldLabel => hint;

  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear, color: MoodleColors.blue),
          onPressed: () {
            query = '';
          },
        )
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back, color: MoodleColors.blue),
        onPressed: () => close(context, ''),
      );

  @override
  Widget buildResults(BuildContext context) => Container();

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? []
        : notes.where((note) {
            final queryText = query.toLowerCase();
            final noteText = note.txtFiltered.toLowerCase();
            return noteText.contains(queryText);
          }).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ListView(
        children: [
          Container(height: 12),
          ...suggestions.map((n) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: NoteCard(
                n,
                token,
                onCheckbox: (value) => NotesService().toggleDone(token, n),
                onPressed: () => _openNoteDialog(context, n),
                onDelete: () => NotesService().deleteNote(token, n),
              ),
            );
          }),
        ],
      ),
    );
  }

  Future _openNoteDialog(BuildContext context, [Note? n]) async =>
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        builder: (context) => NoteEditDialog(
          token: token,
          uid: n?.userid ?? 0,
          cid: n?.courseid ?? 0,
          note: n,
        ),
      );
}