import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moodle_mobile/components/menu_item.dart';

// region Icon and text

class ForumItem extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;

  const ForumItem({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MenuItem(
      icon: const Icon(CupertinoIcons.chat_bubble_2),
      color: Colors.amber,
      title: title,
      onPressed: onPressed,
    );
  }
}

class DocumentItem extends StatelessWidget {
  final String title;
  final String documentUrl;

  const DocumentItem({
    Key? key,
    required this.title,
    required this.documentUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MenuItem(
      icon: const Icon(CupertinoIcons.book),
      color: Colors.pink,
      title: title,
      onPressed: () {
        // TODO: Download this document from link
      },
    );
  }
}

class UrlItem extends StatelessWidget {
  final String title;
  final String url;

  const UrlItem({
    Key? key,
    required this.title,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MenuItem(
      icon: const Icon(CupertinoIcons.link),
      color: Colors.deepPurple,
      title: title,
      onPressed: () {
        // TODO: Go to webpage in browser
      },
    );
  }
}

class SubmissionItem extends StatelessWidget {
  final String title;
  final String submissionId;
  final DateTime? dueDate;

  const SubmissionItem({
    Key? key,
    required this.title,
    required this.submissionId,
    this.dueDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MenuItem(
      icon: const Icon(CupertinoIcons.doc),
      color: Colors.blue,
      title: title,
      subtitle: (dueDate == null)
          ? null
          : DateFormat('dd MMMM, yyyy').format(dueDate!),
      onPressed: () {
        // TODO: Go to submission page using submissionId
      },
    );
  }
}

class QuizItem extends StatelessWidget {
  final String title;
  final String quizId;
  final DateTime? openDate;

  const QuizItem({
    Key? key,
    required this.title,
    required this.quizId,
    this.openDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MenuItem(
      icon: const Icon(CupertinoIcons.question_square),
      color: Colors.blue,
      title: title,
      subtitle: (openDate == null)
          ? null
          : DateFormat('dd MMMM, yyyy').format(openDate!),
      onPressed: () {
        // TODO: Go to quiz page using quizId
      },
    );
  }
}

// endregion

// region Cards

// endregion

// region Text and others

// endregion