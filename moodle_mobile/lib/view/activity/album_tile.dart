import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/models/module/module.dart';
import 'package:moodle_mobile/models/module/module_content.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/activity/album_screen.dart';
import 'package:moodle_mobile/view/activity/image_album_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AlbumTile extends StatelessWidget {
  final Module module;
  final int sectionIndex;
  final bool isTeacher;
  final int courseId;
  final UserStore userStore;
  final Function(bool) reGetContent;
  const AlbumTile({
    Key? key,
    required this.module,
    required this.sectionIndex,
    required this.isTeacher,
    required this.reGetContent,
    required this.courseId,
    required this.userStore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<ModuleContent> images = [];
    for (ModuleContent item in module.contents ?? []) {
      if (item.mimetype?.contains("image") ?? false) {
        if (item.fileurl != null && item.fileurl!.isNotEmpty) {
          item.fileurl = item.fileurl!.replaceAll("?forcedownload=1", "");
          if (item.fileurl?.contains("?token") == false) {
            item.fileurl = item.fileurl! + "?token=" + userStore.user.token;
          }
          images.add(item);
        }
      }
    }
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              module.name ?? "",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: MoodleColors.black80,
              ),
              textScaleFactor: 1.3,
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                    return AlbumScreen(
                      images: images,
                      courseId: courseId,
                      module: module,
                      isTeacher: isTeacher,
                      userStore: userStore,
                      reGetContent: reGetContent,
                      sectionIndex: sectionIndex,
                    );
                  }));
                },
                child: Text(AppLocalizations.of(context)!.see_all,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ))),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
              children: images
                  .map((e) => ImageAlbumTile(
                        src: e.fileurl!,
                        name: e.filename!,
                      ))
                  .toList()),
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
