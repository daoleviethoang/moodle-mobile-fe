import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/constants/dimens.dart';

class UserAvatarCommon extends StatelessWidget {
  const UserAvatarCommon({Key? key, required this.imageURL}) : super(key: key);

  final String imageURL;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(100.0),
        child: Image.network(
          imageURL,
          loadingBuilder: (context, child, progress) {
            return (progress == null)
                ? child
                : Center(
                    child: CircularProgressIndicator(
                      value: progress.expectedTotalBytes != null
                          ? progress.cumulativeBytesLoaded /
                              progress.expectedTotalBytes!
                          : null,
                    ),
                  );
          },
          errorBuilder: (context, exception, stackTrace) {
            return Container(
              height: 56,
              width: 56,
              decoration: const BoxDecoration(color: MoodleColors.blue),
              child: const Icon(
                Icons.person,
                size: 30,
                color: Colors.white,
              ),
            );
          },
        ));
  }
}
