import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/constants/dimens.dart';
import 'package:moodle_mobile/data/network/apis/custom_api/custom_api.dart';
import 'package:moodle_mobile/data/network/apis/file/file_api.dart';
import 'package:moodle_mobile/models/assignment/file_assignment.dart';
import 'package:moodle_mobile/models/module/module.dart';
import 'package:moodle_mobile/models/module/module_content.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/activity/image_album_detail_tile.dart';
import 'package:moodle_mobile/view/common/custom_text_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AlbumScreen extends StatefulWidget {
  final Module module;
  final int sectionIndex;
  final bool isTeacher;
  final int courseId;
  final UserStore userStore;
  final Function(bool) reGetContent;
  final List<ModuleContent> images;
  const AlbumScreen({
    Key? key,
    required this.module,
    required this.sectionIndex,
    required this.isTeacher,
    required this.courseId,
    required this.userStore,
    required this.reGetContent,
    required this.images,
  }) : super(key: key);

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  List<bool> chooseImages = [];
  bool canSave = false;
  bool isRemove = false;
  late Module _module;
  late List<ModuleContent> _images;
  List<FileUpload> files = [];
  TextEditingController nameController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _module = widget.module;
    _images = widget.images;
    nameController = TextEditingController(text: _module.name ?? "");
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      for (var item in _images) {
        var file = await DefaultCacheManager().getSingleFile(
            item.fileurl! + "?token=" + widget.userStore.user.token);
        setState(() {
          files.add(FileUpload(
              filename: item.filename ?? "",
              filepath: file.path,
              filesize: item.filesize ?? 0,
              timeModified: DateTime.fromMillisecondsSinceEpoch(
                  item.timemodified! * 1000),
              fileUrl: item.fileurl ?? ""));
        });
      }
    });
  }

  @override
  void dispose() {
    DefaultCacheManager().emptyCache();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    while (chooseImages.length < files.length) {
      chooseImages.add(false);
    }
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            snap: true,
            actions: <Widget>[
              widget.isTeacher == false || isLoading == true
                  ? Container()
                  : SizedBox(
                      width: 60,
                      height: 60,
                      child: IconButton(
                        iconSize: 28,
                        icon: const Icon(Icons.delete),
                        color: MoodleColors.white,
                        onPressed: () async {
                          var check = await showDialog<bool>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                titlePadding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .deleete_album,
                                      textScaleFactor: 0.8,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .delete_album_description,
                                      textScaleFactor: 0.8,
                                    ),
                                  ],
                                ),
                                actions: [
                                  Row(children: [
                                    Expanded(
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .cancel,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16,
                                            )),
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    MoodleColors.grey),
                                            shape: MaterialStateProperty.all(
                                                const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                8.0))))),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                      child: TextButton(
                                        onPressed: () async {
                                          Navigator.pop(context, true);
                                        },
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .remove,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16,
                                            )),
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    MoodleColors.blue),
                                            shape: MaterialStateProperty.all(
                                                const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                8.0))))),
                                      ),
                                    ),
                                  ]),
                                ],
                              );
                            },
                          );
                          if (check == true) {
                            try {
                              setState(() {
                                isLoading = true;
                              });
                              await CustomApi().deleteModuleInCourse(
                                  widget.userStore.user.token,
                                  widget.module.id ?? 0);
                              widget.reGetContent(true);
                              setState(() {
                                isLoading = false;
                              });
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(e.toString()),
                                      backgroundColor:
                                          Color.fromARGB(255, 58, 44, 43)));
                            }
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
            ],
            title: TextButton(
              onPressed: widget.isTeacher == false
                  ? null
                  : () {
                      showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            titlePadding:
                                const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.new_name_album,
                                  textScaleFactor: 0.8,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  AppLocalizations.of(context)!
                                      .new_name_album_description,
                                  textScaleFactor: 0.8,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                CustomTextFieldWidget(
                                  controller: nameController,
                                  hintText:
                                      AppLocalizations.of(context)!.enter_title,
                                  haveLabel: false,
                                  borderRadius: Dimens.default_border_radius,
                                ),
                              ],
                            ),
                            actions: [
                              Row(children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                        AppLocalizations.of(context)!.cancel,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                        )),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                MoodleColors.grey),
                                        shape: MaterialStateProperty.all(
                                            const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8.0))))),
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: TextButton(
                                    onPressed: () async {
                                      try {
                                        await CustomApi().changeNameModule(
                                            widget.userStore.user.token,
                                            widget.module.id ?? 0,
                                            nameController.text);
                                        widget.reGetContent(true);
                                        setState(() {
                                          _module.name = nameController.text;
                                        });
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(e.toString()),
                                                backgroundColor: Colors.red));
                                      }
                                      Navigator.pop(context);
                                    },
                                    child:
                                        Text(AppLocalizations.of(context)!.save,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16,
                                            )),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                MoodleColors.blue),
                                        shape: MaterialStateProperty.all(
                                            const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8.0))))),
                                  ),
                                ),
                              ]),
                            ],
                          );
                        },
                      );
                    },
              child: Text(
                _module.name ?? "",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
                overflow: TextOverflow.clip,
              ),
            ),
            leading: TextButton(
              style: TextButton.styleFrom(
                primary: Colors.white,
              ),
              child: const Icon(CupertinoIcons.back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : StaggeredGrid.count(
                crossAxisCount: 2,
                children: files
                    .map((e) => ImageAlbumDetailTile(
                          src: e.fileUrl,
                          name: "",
                          filePath: null, //e.filepath,
                          isChoose: chooseImages[files.indexOf(e)],
                          setLongPress: (bool value) {
                            setState(() {
                              chooseImages[files.indexOf(e)] = value;
                            });
                          },
                        ))
                    .toList(),
              ),
      ),
      floatingActionButton: widget.isTeacher == false || isLoading == true
          ? Container()
          : chooseImages.any((element) => element == true)
              ? FloatingActionButton(
                  child: const Icon(
                    Icons.delete,
                    color: MoodleColors.black80,
                  ),
                  foregroundColor: MoodleColors.white,
                  backgroundColor: MoodleColors.white,
                  onPressed: () async {
                    List<FileUpload> tempFiles = [];
                    for (var i = 0; i < chooseImages.length; i++) {
                      if (chooseImages[i] == false) {
                        tempFiles.add(files[i]);
                      }
                    }
                    try {
                      int? itemId = await FileApi().uploadMultipleFile(
                          widget.userStore.user.token, tempFiles);
                      if (itemId != null) {
                        await CustomApi().changeFileInFolderCourse(
                            widget.userStore.user.token,
                            _module.id ?? 0,
                            itemId);
                        setState(() {
                          files = tempFiles;
                        });
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(e.toString()),
                          backgroundColor: Colors.red));
                    }
                  },
                )
              : FloatingActionButton(
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  foregroundColor: MoodleColors.blue,
                  backgroundColor: MoodleColors.blue,
                  onPressed: () async {
                    try {
                      FilePickerResult? result = await FilePicker.platform
                          .pickFiles(type: FileType.image);
                      if (result != null && result.files.isNotEmpty) {
                        var file = result.files.first;
                        var tempFiles = files;
                        setState(() {
                          tempFiles.add(FileUpload(
                            filename: file.name,
                            filepath: file.path ?? "",
                            filesize: file.size,
                            timeModified: DateTime.now(),
                          ));
                        });

                        int? itemId = await FileApi().uploadMultipleFile(
                            widget.userStore.user.token, tempFiles);

                        if (itemId != null) {
                          await CustomApi().changeFileInFolderCourse(
                              widget.userStore.user.token,
                              _module.id ?? 0,
                              itemId);
                          await widget.reGetContent(true);
                          setState(() {
                            files = tempFiles;
                          });
                        }
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(e.toString()),
                          backgroundColor: Colors.red));
                    }
                  },
                ),
    );
  }
}
