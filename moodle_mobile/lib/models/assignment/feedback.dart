class FeedBack {
  Grade? grade;
  String? gradefordisplay;
  int? gradeddate;
  List<Plugins>? plugins;

  FeedBack({this.grade, this.gradefordisplay, this.gradeddate, this.plugins});

  FeedBack.fromJson(Map<String, dynamic> json) {
    grade = json['grade'] != null ? Grade.fromJson(json['grade']) : null;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    if (grade != null) {
      data['grade'] = grade!.toJson();
    }
    data['gradefordisplay'] = gradefordisplay;
    data['gradeddate'] = gradeddate;
    if (plugins != null) {
      data['plugins'] = plugins!.map((v) => v.toJson()).toList();
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
  int? courseid;
  String? rawgrade;
  String? courseName;

  Grade({
    this.id,
    this.assignment,
    this.userid,
    this.attemptnumber,
    this.timecreated,
    this.timemodified,
    this.grader,
    this.grade,
    this.courseid,
    this.rawgrade,
    this.courseName,
  });

  Grade.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    assignment = json['assignment'];
    userid = json['userid'];
    attemptnumber = json['attemptnumber'];
    timecreated = json['timecreated'];
    timemodified = json['timemodified'];
    grader = json['grader'];
    grade = json['grade'];
    courseid = json['courseid'];
    rawgrade = json['rawgrade'];
    courseName = json['courseName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['assignment'] = assignment;
    data['userid'] = userid;
    data['attemptnumber'] = attemptnumber;
    data['timecreated'] = timecreated;
    data['timemodified'] = timemodified;
    data['grader'] = grader;
    data['grade'] = grade;
    data['courseid'] = courseid;
    data['rawgrade'] = rawgrade;
    data['courseName'] = courseName;
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
        fileareas!.add(Fileareas.fromJson(v));
      });
    }
    if (json['editorfields'] != null) {
      editorfields = [];
      json['editorfields'].forEach((v) {
        editorfields!.add(Editorfields.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['name'] = name;
    if (fileareas != null) {
      data['fileareas'] = fileareas!.map((v) => v.toJson()).toList();
    }
    if (editorfields != null) {
      data['editorfields'] = editorfields!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['area'] = area;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['description'] = description;
    data['text'] = text;
    data['format'] = format;
    return data;
  }
}