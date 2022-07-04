import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/constants/dimens.dart';
import 'package:moodle_mobile/constants/styles.dart';
import 'package:moodle_mobile/models/note/note.dart';

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
  final VoidCallback? onPressed;

  const NoteCard(
    this.note,
    this.token, {
    Key? key,
    this.onPressed,
  }) : super(key: key);

  @override
  _NoteCardState createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  late String _token;
  late Note _note;

  @override
  void initState() {
    super.initState();
    _token = widget.token;
    _note = widget.note;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: widget.onPressed,
        borderRadius: const BorderRadius.all(
            Radius.circular(Dimens.default_card_radius)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Checkbox(
                  value: _note.isDone,
                  onChanged: (value) {},
                ),
              ),
              Expanded(
                child: Opacity(
                  opacity: _note.isDone ? .5 : 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                            }
                          ),
                        ],
                      ),
                      Container(height: 4),
                      Text(
                        _note.txt,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          decoration: _note.isDone
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(width: 16),
            ],
          ),
        ),
      ),
    );
  }
}