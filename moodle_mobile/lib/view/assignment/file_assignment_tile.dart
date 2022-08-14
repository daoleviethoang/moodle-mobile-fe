import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:moodle_mobile/data/network/apis/file/file_api.dart';
import 'package:moodle_mobile/models/assignment/file_assignment.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/assignment/rename_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

typedef Int2VoidFunc = void Function(int);
typedef Int2StringVoidFunc = void Function(int, String);

class FileAssignmentTile extends StatefulWidget {
  final FileUpload file;
  final Int2StringVoidFunc rename;
  final Int2VoidFunc delete;
  final int index;
  final bool canEdit;
  const FileAssignmentTile({
    Key? key,
    required this.file,
    required this.rename,
    required this.canEdit,
    required this.delete,
    required this.index,
  }) : super(key: key);

  @override
  State<FileAssignmentTile> createState() => _FileAssignmentTileState();
}

class _FileAssignmentTileState extends State<FileAssignmentTile> {
  late UserStore _userStore;
  List<String> action = [];
  _showReNameDialog() {
    final RenameFileTiles _setListTiles = RenameFileTiles(
      filename: widget.file.filename,
    );
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.rename_file),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _setListTiles,
              ],
            ),
          ),
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
                  widget.rename(widget.index, _setListTiles.filename);
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
  }

  downloadFile() async {
    await FileApi().downloadFile(
        _userStore.user.token, widget.file.fileUrl, widget.file.filename);
  }

  void handleClick(String value) {
    if (value == AppLocalizations.of(context)!.rename) {
      _showReNameDialog();
    }
    if (value == AppLocalizations.of(context)!.download) {
      downloadFile();
    }
    if (value == AppLocalizations.of(context)!.delete) {
      widget.delete(widget.index);
    }
  }

  @override
  void initState() {
    _userStore = GetIt.instance<UserStore>();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => setState(
        () {
          action = [
            AppLocalizations.of(context)!.rename,
            AppLocalizations.of(context)!.download,
            AppLocalizations.of(context)!.delete,
          ];
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                MaterialButton(
                  shape: const CircleBorder(),
                  color: const Color.fromARGB(255, 217, 217, 217),
                  padding: const EdgeInsets.all(20),
                  onPressed: () {},
                  child: const Icon(
                    Icons.file_copy,
                    size: 20,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.file.filename,
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                          DateFormat("hh:mmaa, dd MMMM, yyyy")
                              .format(widget.file.timeModified),
                          style: const TextStyle(
                              fontSize: 11, fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: handleClick,
                  itemBuilder: (BuildContext context) {
                    if (widget.file.fileUrl == "") {
                      action.remove(AppLocalizations.of(context)!.download);
                    }
                    if (widget.canEdit == false) {
                      action.remove(AppLocalizations.of(context)!.rename);
                      action.remove(AppLocalizations.of(context)!.delete);
                    }
                    return action.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}