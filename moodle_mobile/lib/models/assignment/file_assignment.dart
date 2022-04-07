class FileAssignment {
  String filename;
  String filepath;
  int filesize;
  String fileUrl;
  DateTime timeModified;
  FileAssignment(
      {required this.filename,
      required this.filepath,
      required this.filesize,
      this.fileUrl = "",
      required this.timeModified});
}
