import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  final VoidCallback? onPressed;

  const NoteCard(
    this.note, {
    Key? key,
    this.onPressed,
  }) : super(key: key);

  @override
  _NoteCardState createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  late Note _note;

  @override
  void initState() {
    super.initState();
    _note = widget.note;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: widget.onPressed,
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
                      Text(
                        _note.getCourseName(context),
                        style: MoodleStyles.noteHeaderStyle.copyWith(
                          color: _note.isImportant
                              ? Colors.amber
                              : Theme.of(context).textTheme.titleMedium?.color,
                          decoration: _note.isDone
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      Container(height: 4),
                      Text(
                        _note.title ?? _note.content ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: _note.isImportant
                              ? Colors.amber
                              : Theme.of(context).textTheme.bodyMedium?.color,
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