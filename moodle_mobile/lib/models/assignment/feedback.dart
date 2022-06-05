class FeedBack {
  Grade? grade;
  String? gradefordisplay;
  int? gradeddate;
  List<Plugins>? plugins;

  FeedBack({this.grade, this.gradefordisplay, this.gradeddate, this.plugins});

  FeedBack.fromJson(Map<String, dynamic> json) {
    grade = json['grade'] != null ? new Grade.fromJson(json['grade']) : null;
    gradefordisplay = json['gradefordisplay'];
    gradeddate = json['gradeddate'];
    if (json['plugins'] != null) {
      plugins = [];
      json['plugins'].forEach((v) {
        plugins!.add(Plugins.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.grade != null) {
      data['grade'] = this.grade!.toJson();
    }
    data['gradefordisplay'] = this.gradefordisplay;
    data['gradeddate'] = this.gradeddate;
    if (this.plugins != null) {
      data['plugins'] = this.plugins!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Grade {
  int? id;
  int? assignment;
  int? userid;
  int? attemptnumber;
  int? timecreated;
  int? timemodified;
  int? grader;
  String? grade;

  Grade(
      {this.id,
      this.assignment,
      this.userid,
      this.attemptnumber,
      this.timecreated,
      this.timemodified,
      this.grader,
      this.grade});

  Grade.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    assignment = json['assignment'];
    userid = json['userid'];
    attemptnumber = json['attemptnumber'];
    timecreated = json['timecreated'];
    timemodified = json['timemodified'];
    grader = json['grader'];
    grade = json['grade'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['assignment'] = this.assignment;
    data['userid'] = this.userid;
    data['attemptnumber'] = this.attemptnumber;
    data['timecreated'] = this.timecreated;
    data['timemodified'] = this.timemodified;
    data['grader'] = this.grader;
    data['grade'] = this.grade;
    return data;
  }
}

class Plugins {
  String? type;
  String? name;
  List<Fileareas>? fileareas;
  List<Editorfields>? editorfields;

  Plugins({this.type, this.name, this.fileareas, this.editorfields});

  Plugins.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    name = json['name'];
    if (json['fileareas'] != null) {
      fileareas = [];
      json['fileareas'].forEach((v) {
        fileareas!.add(new Fileareas.fromJson(v));
      });
    }
    if (json['editorfields'] != null) {
      editorfields = [];
      json['editorfields'].forEach((v) {
        editorfields!.add(new Editorfields.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['name'] = this.name;
    if (this.fileareas != null) {
      data['fileareas'] = this.fileareas!.map((v) => v.toJson()).toList();
    }
    if (this.editorfields != null) {
      data['editorfields'] = this.editorfields!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Fileareas {
  String? area;

  Fileareas({this.area});

  Fileareas.fromJson(Map<String, dynamic> json) {
    area = json['area'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['area'] = this.area;
    return data;
  }
}

class Editorfields {
  String? name;
  String? description;
  String? text;
  int? format;

  Editorfields({this.name, this.description, this.text, this.format});

  Editorfields.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    text = json['text'];
    format = json['format'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['description'] = this.description;
    data['text'] = this.text;
    data['format'] = this.format;
    return data;
  }
}
