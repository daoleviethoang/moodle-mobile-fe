import 'package:flutter/material.dart';

class QuizSelectTile extends StatelessWidget {
  final bool isChoose;
  final Function(int) selectPage;
  final int page;
  const QuizSelectTile(
      {Key? key,
      required this.isChoose,
      required this.selectPage,
      required this.page})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
