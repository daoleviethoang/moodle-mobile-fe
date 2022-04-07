import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:moodle_mobile/models/assignment/assignment.dart';
import 'package:moodle_mobile/models/assignment/attemp_assignment.dart';
import 'package:moodle_mobile/models/assignment/file_assignment.dart';
import 'package:file_picker/file_picker.dart';
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
      sum += double.parse((item.filesize / 1024).toStringAsFixed(2));
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 5, right: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        "Submission size",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        caculateMbSize().toString() +
                            "MB" +
                            "/" +
                            (widget.maxByteSize / 1024).ceil().toString() +
                            "MB",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        "Submission count",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
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
              ]),
              InkWell(
                child: Row(children: const [
                  Text("Name"),
                  Icon(Icons.arrow_drop_down),
                ]),
                onTap: () {
                  setState(() {
                    sortASC = !sortASC;
                    files.reversed;
                  });
                },
              ),
              ListView(
                primary: false,
                shrinkWrap: true,
                children: files.map((e) => Text(e.filename)).toList(),
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
      floatingActionButton: InkWell(
        child: const Icon(Icons.add),
        onTap: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles();
          if (result != null) {
            PlatformFile file = result.files.first;
            files.add(FileAssignment(
                filename: file.name,
                filepath: file.path!,
                filesize: file.size));
            files.sort(((a, b) => a.filename.compareTo(b.filename)));
            if (sortASC == false) {
              files.reversed;
            }
          }
        },
      ),
    );
  }
}
