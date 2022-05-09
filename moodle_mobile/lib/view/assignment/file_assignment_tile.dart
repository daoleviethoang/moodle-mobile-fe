import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:moodle_mobile/data/network/apis/file/file_api.dart';
import 'package:moodle_mobile/models/assignment/file_assignment.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/assignment/rename_dialog.dart';

typedef Int2VoidFunc = void Function(int);
typedef Int2StringVoidFunc = void Function(int, String);

class FileAssignmentTile extends StatefulWidget {
  final FileUpload file;
  final Int2StringVoidFunc rename;
  final Int2VoidFunc delete;
  final int index;
  const FileAssignmentTile({
    Key? key,
    required this.file,
    required this.rename,
    required this.delete,
    required this.index,
  }) : super(key: key);

  @override
  State<FileAssignmentTile> createState() => _FileAssignmentTileState();
}

class _FileAssignmentTileState extends State<FileAssignmentTile> {
  late UserStore _userStore;
  ReceivePort _port = ReceivePort();
  List<String> action = ['Rename...', 'Download', 'Delete...'];
  _showReNameDialog() {
    final RenameFileTiles _setListTiles = RenameFileTiles(
      filename: widget.file.filename,
    );
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Rename your file!'),
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
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  widget.rename(widget.index, _setListTiles.filename);
                });

                // break dialog
                Navigator.pop(context);
              },
              child: Text("Ok"),
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
    switch (value) {
      case 'Rename...':
        _showReNameDialog();
        break;
      case 'Download':
        downloadFile();
        break;
      case 'Delete...':
        widget.delete(widget.index);
        break;
    }
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  @override
  void initState() {
    _userStore = GetIt.instance<UserStore>();
    super.initState();

    _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();

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
                  shape: CircleBorder(),
                  color: Color.fromARGB(255, 217, 217, 217),
                  padding: EdgeInsets.all(20),
                  onPressed: () {},
                  child: Icon(
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
                      action.remove('Download');
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
