import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DescriptionCommonView extends StatelessWidget {
  final String description;

  const DescriptionCommonView({Key? key, required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 10,
      margin: const EdgeInsets.only(bottom: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(
            left: 20.0, top: 20.0, right: 20.0, bottom: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              AppLocalizations.of(context)!.description,
              style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                  letterSpacing: 0.27,
                  color: MoodleColors.black),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                description,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    height: 1.8,
                    fontSize: 13,
                    letterSpacing: 0.0,
                    wordSpacing: 0.1,
                    color: MoodleColors.black),
              ),
            )
          ],
        ),
      ),
    );
  }
}