import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:moodle_mobile/view/common/menu_item.dart';

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
      subtitle: url,
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

class AttachmentItem extends StatelessWidget {
  final String title;
  final String attachmentUrl;

  const AttachmentItem({
    Key? key,
    required this.title,
    required this.attachmentUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MenuItem(
      icon: const Icon(CupertinoIcons.doc),
      color: Colors.grey,
      title: title,
      onPressed: () {
        // TODO: Download this document from link
      },
    );
  }
}

// endregion

// region Cards

class RichTextCard extends StatelessWidget {
  final String text;

  const RichTextCard({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Html(
          data: text,
          style: {
            'h1': Style(fontSize: const FontSize(19)),
            'h2': Style(fontSize: const FontSize(17.5)),
            'h3': Style(fontSize: const FontSize(16)),
          },
        ),
      ),
    );
  }
}

// endregion

// region Text and others

class HeaderItem extends StatelessWidget {
  final String text;

  const HeaderItem({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class LineItem extends StatelessWidget {
  final double width;

  const LineItem({Key? key, this.width = 1.5}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Container(
        color: Theme.of(context).hintColor.withOpacity(.25),
        width: double.infinity,
        height: width,
      ),
    );
  }
}

// endregion