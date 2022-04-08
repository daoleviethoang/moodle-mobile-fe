import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:moodle_mobile/models/assignment/assignment.dart';
import 'package:moodle_mobile/models/assignment/attemp_assignment.dart';
import 'package:moodle_mobile/models/assignment/file_assignment.dart';
import 'package:file_picker/file_picker.dart';
import 'package:moodle_mobile/models/assignment/files_assignment.dart';
import 'package:moodle_mobile/view/assignment/file_assignment_tile.dart';
import 'package:moodle_mobile/view/common/custom_button.dart';

class FilesAssignmentScreen extends StatefulWidget {
  final int maxByteSize;
  final int maxFileCount;
  final AttemptAssignment attempt;
  final VoidCallback reload;
  const FilesAssignmentScreen(
      {Key? key,
      required this.maxByteSize,
      required this.maxFileCount,
      required this.attempt,
      required this.reload})
      : super(key: key);

  @override
  _FilesAssignmentScreenState createState() => _FilesAssignmentScreenState();
}

class _FilesAssignmentScreenState extends State<FilesAssignmentScreen> {
  Assignment assignment = Assignment();
  bool sortASC = true;
  List<FileAssignment> files = [];
  int mbSize = 0;

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
            title: const Text('Overwrite same name file!'),
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
                    files[index] = FileAssignment(
                        filename: file.name,
                        filepath: file.path ?? "",
                        timeModified: DateTime.now(),
                        filesize: file.size);
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
      return true;
    }
    return false;
  }

  @override
  void initState() {
    for (Files item
        in widget.attempt.submission?.plugins?[0].fileareas?[0].files ?? []) {
      setState(() {
        files.add(FileAssignment(
            filename: item.filename ?? "",
            filepath: item.filepath ?? "",
            filesize: item.filesize ?? 0,
            timeModified:
                DateTime.fromMillisecondsSinceEpoch(item.timemodified! * 1000),
            fileUrl: item.fileurl ?? ""));
      });
    }
    setState(() {
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
      body: SingleChildScrollView(
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
                          const Text(
                            "Submission size",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
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
                            style: TextStyle(
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
                          const Text(
                            "Submission count",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
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
              SizedBox(
                height: 20,
              ),
              InkWell(
                child: Row(children: [
                  Text("Name"),
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
                padding: EdgeInsets.only(top: 0),
                shrinkWrap: true,
                itemCount: files.length,
                itemBuilder: (BuildContext context, int index) {
                  return FileAssignmentTile(
                    file: files[index],
                    rename: rename,
                    delete: delete,
                    index: index,
                  );
                },
              ),
              SizedBox(
                height: 10,
              ),
              CustomButtonWidget(
                textButton: "Save submission",
                onPressed: () {
                  widget.reload();
                },
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles();
          if (result != null) {
            PlatformFile file = result.files.first;
            // check size more than condition
            if (file.size + caculateByteSize() > widget.maxByteSize) {
              const snackBar = SnackBar(content: Text("File's size is bigger"));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              return;
            }
            // check number file more than condition
            if (files.length == widget.maxFileCount) {
              const snackBar = SnackBar(content: Text("Number file is full"));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              return;
            }
            // check file same name
            bool check = checkOverwrite(file);
            if (check == true) return;
            // add file
            files.add(FileAssignment(
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
        },
      ),
    );
  }
}
