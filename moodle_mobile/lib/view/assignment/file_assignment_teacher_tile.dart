
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:moodle_mobile/data/network/apis/file/file_api.dart';
import 'package:moodle_mobile/models/assignment/file_assignment.dart';
import 'package:moodle_mobile/store/user/user_store.dart';

typedef Int2VoidFunc = void Function(int);
typedef Int2StringVoidFunc = void Function(int, String);

class FileAssignmentTeacherTile extends StatefulWidget {
  final FileUpload file;
  const FileAssignmentTeacherTile({
    Key? key,
    required this.file,
  }) : super(key: key);

  @override
  State<FileAssignmentTeacherTile> createState() =>
      _FileAssignmentTeacherTileState();
}

class _FileAssignmentTeacherTileState extends State<FileAssignmentTeacherTile> {
  late UserStore _userStore;

  downloadFile() async {
    await FileApi().downloadFile(
        _userStore.user.token, widget.file.fileUrl, widget.file.filename);
  }

  @override
  void initState() {
    _userStore = GetIt.instance<UserStore>();
    super.initState();
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
                IconButton(
                  onPressed: downloadFile,
                  icon: const Icon(Icons.download),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}