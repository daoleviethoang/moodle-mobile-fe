import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/constants/dimens.dart';
import 'package:moodle_mobile/constants/styles.dart';
import 'package:moodle_mobile/models/note/note.dart';

import 'content_item.dart';

class LoadingCard extends StatelessWidget {
  final String? text;

  const LoadingCard({Key? key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator.adaptive(),
          Container(height: 16),
          Text(
            text ?? 'Loading',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
        ],
      ),
    );
  }
}

class ErrorCard extends StatelessWidget {
  final String? text;

  const ErrorCard({Key? key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (kReleaseMode) {
      return Container();
    }
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.warning_rounded,
            size: 54,
            color: Theme.of(context).colorScheme.error,
          ),
          Container(height: 16),
          Text(
            'Error in testing mode',
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          Container(height: 16),
          Text(
            text ?? 'Something happened. Please try again later.',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
      ),
    );
  }
}

class NoteCard extends StatefulWidget {
  final Note note;
  final String token;
  final Future Function(bool)? onCheckbox;
  final Future Function()? onPressed;
  final Future Function()? onDelete;

  const NoteCard(
    this.note,
    this.token, {
    Key? key,
    this.onCheckbox,
    this.onPressed,
    this.onDelete,
  }) : super(key: key);

  @override
  _NoteCardState createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  late String _token;
  late Note _note;

  Widget _cardBase = Container();

  var _loading = false;
  var _hiding = false;

  @override
  void initState() {
    super.initState();
    _token = widget.token;
    _note = widget.note;
  }

  void _initCardBase() {
    _cardBase = InkWell(
      onTap: widget.onPressed == null
          ? null
          : () async {
              setState(() => _loading = true);
              await widget.onPressed!();
              refreshData();
            },
      borderRadius:
          const BorderRadius.all(Radius.circular(Dimens.default_card_radius)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Checkbox(
                value: _note.isDone,
                onChanged: widget.onCheckbox == null
                    ? null
                    : (value) async {
                        if (value != null) {
                          setState(() => _loading = true);
                          await widget.onCheckbox!(value);
                          refreshData();
                        }
                      },
              ),
            ),
            Expanded(
              child: Opacity(
                opacity: _note.isDone ? .5 : 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (_note.isImportant)
                          Icon(Icons.star_rounded,
                              size: 16,
                              color: _note.isNotDone
                                  ? Colors.amber
                                  : MoodleColors.black80),
                        if (_note.isRecent)
                          Icon(Icons.schedule_rounded,
                              size: 16,
                              color: MoodleColors.black80.withOpacity(.75)),
                        if (_note.isImportant || _note.isRecent)
                          Container(width: 4),
                        FutureBuilder(
                            future: _note.getCourseName(context, _token),
                            builder: (context, snapshot) {
                              String courseName = '…';
                              if (snapshot.hasData) {
                                courseName = snapshot.data as String;
                              } else if (snapshot.hasError) {
                                if (kDebugMode) print(snapshot.error);
                                return Container();
                              }

                              return Text(
                                courseName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: MoodleStyles.noteHeaderStyle.copyWith(
                                  decoration: _note.isDone
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              );
                            }),
                      ],
                    ),
                    Container(height: 4),
                    Builder(builder: (context) {
                      final htmlStyle = MoodleStyles.htmlStyle
                        ..addAll({
                          '*': Style(
                            textDecoration: _note.isDone
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        });
                      return RichTextCard(
                        text: _note.txtFiltered,
                        style: htmlStyle,
                        hasPadding: false,
                      );
                    }),
                  ],
                ),
              ),
            ),
            Container(width: 16),
          ],
        ),
      ),
    );
  }

  Future refreshData() async {
    try {
      final newNote = await _note.refreshData(_token);
      await Future.delayed(const Duration(milliseconds: 300));
      if (newNote != null) {
        setState(() {
          _loading = false;
          _note = newNote;
        });
      } else {
        setState(() => _hiding = true);
      }
    } catch (e) {
      if (kDebugMode) print('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hiding && !_loading) return Container();
    _initCardBase();

    return IgnorePointer(
      ignoring: _loading,
      child: AnimatedScale(
        scale: _hiding ? 0 : 1,
        alignment: Alignment.topCenter,
        duration: const Duration(milliseconds: 300),
        onEnd: () {
          if (_hiding) {
            setState(() => _loading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(AppLocalizations.of(context)!.note_deleted)),
            );
          }
        },
        child: AnimatedOpacity(
          opacity: _loading ? .5 : 1,
          duration: const Duration(milliseconds: 300),
          child: Card(
            child: Slidable(
              key: const ValueKey(0),
              child: _cardBase,
              endActionPane: ActionPane(
                extentRatio: .6,
                motion: const BehindMotion(),
                children: [
                  SlidableAction(
                    onPressed: widget.onDelete == null
                        ? null
                        : (context) async {
                            setState(() => _loading = true);
                            await widget.onDelete!();
                            refreshData();
                          },
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: CupertinoIcons.trash_fill,
                    label: AppLocalizations.of(context)!.delete,
                  ),
                  SlidableAction(
                    onPressed: (context) async {
                      await Clipboard.setData(
                          ClipboardData(text: _note.txtFormatted));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text(AppLocalizations.of(context)!.copied)),
                      );
                    },
                    backgroundColor: MoodleColors.green_icon_status,
                    foregroundColor: Colors.white,
                    icon: CupertinoIcons.doc_on_doc_fill,
                    label: AppLocalizations.of(context)!.copy,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(Dimens.default_card_radius),
                      bottomRight: Radius.circular(Dimens.default_card_radius),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}