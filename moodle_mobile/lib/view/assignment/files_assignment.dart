import 'dart:io';

import 'package:document_scanner_flutter/configs/configs.dart';
import 'package:document_scanner_flutter/document_scanner_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/constants/dimens.dart';
import 'package:moodle_mobile/data/network/apis/assignment/assignment_api.dart';
import 'package:moodle_mobile/data/network/apis/file/file_api.dart';
import 'package:moodle_mobile/models/assignment/assignment.dart';
import 'package:moodle_mobile/models/assignment/attemp_assignment.dart';
import 'package:moodle_mobile/models/assignment/file_assignment.dart';
import 'package:file_picker/file_picker.dart';
import 'package:moodle_mobile/models/assignment/files_assignment.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/assignment/file_assignment_tile.dart';
import 'package:moodle_mobile/view/common/custom_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FilesAssignmentScreen extends StatefulWidget {
  final int maxByteSize;
  final int maxFileCount;
  final AttemptAssignment attempt;
  final int assignId;
  final int dueDate;
  final VoidCallback reload;
  final bool canEdit;
  const FilesAssignmentScreen({
    Key? key,
    required this.maxByteSize,
    required this.maxFileCount,
    required this.attempt,
    required this.reload,
    required this.assignId,
    required this.dueDate,
    required this.canEdit,
  }) : super(key: key);

  @override
  _FilesAssignmentScreenState createState() => _FilesAssignmentScreenState();
}

class _FilesAssignmentScreenState extends State<FilesAssignmentScreen> {
  Assignment assignment = Assignment();
  late UserStore _userStore;
  bool sortASC = true;
  List<FileUpload> files = [];
  int mbSize = 0;
  bool disable = false;
  bool isLoading = false;
  bool isSaveFile = false;

  double caculateMbSize() {
    double sum = 0;
    for (var item in files) {
      sum += double.parse((item.filesize / 1024 / 1024).toStringAsFixed(2));
    }
    return sum;
  }

  int caculateByteSize() {
    int sum = 0;
    for (var item in files) {
      sum += item.filesize;
    }
    return sum;
  }

  bool checkOverwrite(PlatformFile file) {
    int index = -1;
    for (var i = 0; i < files.length; i++) {
      if (files[i].filename == file.name) {
        index = i;
        break;
      }
    }
    if (index != -1) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.override_file),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(AppLocalizations.of(context)!.cancel),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    files[index] = FileUpload(
                        filename: file.name,
                        filepath: file.path ?? "",
                        timeModified: DateTime.now(),
                        filesize: file.size);
                  });

                  // break dialog
                  Navigator.pop(context);
                },
                child: Text(AppLocalizations.of(context)!.ok),
              ),
            ],
          );
        },
      );
      return true;
    }
    return false;
  }

  Widget buildBottomDialog(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 20, left: 10, right: 10),
      decoration: const BoxDecoration(
        color: MoodleColors.grey_bottom_bar,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Dimens.default_sheet_radius),
          topRight: Radius.circular(Dimens.default_sheet_radius),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            height: 5,
            width: 134,
            decoration: const BoxDecoration(
              color: MoodleColors.line_bottom_bar,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 8),
            decoration: const BoxDecoration(
              color: MoodleColors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 30, bottom: 5, top: 5, right: 30),
              child: TextButton.icon(
                onPressed: () async {
                  await getFileFromStorage();
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.library_add,
                  color: MoodleColors.black,
                  size: 30,
                ),
                label: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    AppLocalizations.of(context)!.get_file_from_storage,
                    style: const TextStyle(
                        color: MoodleColors.black, fontSize: 16),
                  ),
                ),
                style: TextButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  primary: MoodleColors.white,
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: MoodleColors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 30, bottom: 5, top: 5, right: 30),
              child: TextButton.icon(
                onPressed: () async {
                  await scanFile();
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.document_scanner,
                  color: MoodleColors.black,
                  size: 30,
                ),
                label: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    AppLocalizations.of(context)!.scan_file_camera,
                    style: const TextStyle(
                        color: MoodleColors.black, fontSize: 16),
                  ),
                ),
                style: TextButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  primary: MoodleColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  getFileFromStorage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        PlatformFile file = result.files.first;
        // check size more than condition
        if (file.size + caculateByteSize() > widget.maxByteSize) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(AppLocalizations.of(context)!.file_size_bigger),
              backgroundColor: Colors.red));
          return;
        }
        // check number file more than condition
        if (files.length == widget.maxFileCount) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(AppLocalizations.of(context)!.number_file_full),
              backgroundColor: Colors.red));
          return;
        }
        // check file same name
        bool check = checkOverwrite(file);
        if (check == true) return;
        // add file
        files.add(FileUpload(
            filename: file.name,
            filepath: file.path ?? "",
            timeModified: DateTime.now(),
            filesize: file.size));
        setState(() {
          files.sort(((a, b) => a.filename.compareTo(b.filename)));
          if (sortASC == false) {
            files.reversed;
          }
        });
      }
    } catch (error) {
      print(error.toString());
    }
  }

  scanFile() async {
    try {
      File? scannedDoc = await DocumentScannerFlutter.launchForPdf(context,
          source: ScannerFileSource.CAMERA); // Or ScannerFileSource.GALLERY
      if (scannedDoc != null) {
        String fileName = scannedDoc.path.split('/').last;
        int byte = scannedDoc.readAsBytesSync().lengthInBytes;

        if (byte + caculateByteSize() > widget.maxByteSize) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(AppLocalizations.of(context)!.file_size_bigger),
              backgroundColor: Colors.red));
          return;
        }
        // check number file more than condition
        if (files.length == widget.maxFileCount) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(AppLocalizations.of(context)!.number_file_full),
              backgroundColor: Colors.red));
          return;
        }

        files.add(FileUpload(
            filename: fileName,
            filepath: scannedDoc.path,
            timeModified: DateTime.now(),
            filesize: byte));
        setState(() {
          files.sort(((a, b) => a.filename.compareTo(b.filename)));
          if (sortASC == false) {
            files.reversed;
          }
        });
      }
    } on PlatformException {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Platform exception"), backgroundColor: Colors.red));
    }
  }

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    _userStore = GetIt.instance<UserStore>();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      for (Files item
          in widget.attempt.submission?.plugins?[0].fileareas?[0].files ?? []) {
        if (item.fileurl != null) {
          var file = await DefaultCacheManager()
              .getSingleFile(item.fileurl! + "?token=" + _userStore.user.token);
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
      }
      setState(() {
        isLoading = false;
      });
    });
    setState(() {
      disable = !widget.canEdit;
      files.sort(((a, b) => a.filename.compareTo(b.filename)));
    });
    super.initState();
  }

  void rename(int index, String newName) {
    setState(() {
      files[index].filename = newName;
    });
  }

  void delete(int index) {
    setState(() {
      files.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            snap: true,
            title: Text(
              AppLocalizations.of(context)!.submission,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
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
            : SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of(context)!.max_file_size,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    caculateMbSize().toString() +
                                        "MB" +
                                        "/" +
                                        (widget.maxByteSize / 1024 / 1024)
                                            .ceil()
                                            .toString() +
                                        "MB",
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of(context)!
                                        .default_num_file,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    files.length.toString() +
                                        "/" +
                                        widget.maxFileCount.toString() +
                                        " files",
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        child: Row(children: [
                          Text(AppLocalizations.of(context)!.name),
                          Icon(sortASC == true
                              ? Icons.arrow_drop_down
                              : Icons.arrow_drop_up),
                        ]),
                        onTap: () {
                          setState(() {
                            sortASC = !sortASC;
                            files = files.reversed.toList();
                          });
                        },
                      ),
                      ListView.builder(
                        padding: const EdgeInsets.only(top: 0),
                        shrinkWrap: true,
                        itemCount: files.length,
                        itemBuilder: (BuildContext context, int index) {
                          return FileAssignmentTile(
                            file: files[index],
                            rename: rename,
                            canEdit: widget.canEdit,
                            delete: delete,
                            index: index,
                          );
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomButtonWidget(
                        textButton:
                            AppLocalizations.of(context)!.save_submission,
                        onPressed: disable
                            ? null
                            : () async {
                                setState(() {
                                  isSaveFile = true;
                                });
                                try {
                                  int? itemId = await FileApi()
                                      .uploadMultipleFile(
                                          _userStore.user.token, files);
                                  if (itemId != null) {
                                    await AssignmentApi().saveAssignment(
                                        _userStore.user.token,
                                        widget.assignId,
                                        itemId);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text("Submit success"),
                                            backgroundColor: Colors.green));
                                    widget.reload();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text("Can't found any file"),
                                            backgroundColor: Colors.red));
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(e.toString()),
                                          backgroundColor: Colors.red));
                                }
                                setState(() {
                                  isSaveFile = false;
                                });
                              },
                      ),
                      isSaveFile
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
      ),
      floatingActionButton: isLoading
          ? Container()
          : FloatingActionButton(
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              foregroundColor: disable ? Colors.black54 : MoodleColors.blue,
              backgroundColor: disable ? Colors.black54 : MoodleColors.blue,
              onPressed: disable
                  ? null
                  : () async {
                      try {
                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          builder: (builder) => buildBottomDialog(builder),
                        );
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
