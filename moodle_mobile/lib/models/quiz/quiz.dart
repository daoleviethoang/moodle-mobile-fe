class Quiz {
  int? id;
  int? course;
  int? coursemodule;
  String? name;
  String? intro;
  int? introformat;
  int? timeopen;
  int? timeclose;
  int? timelimit;
  String? preferredbehaviour;
  int? attempts;
  int? grademethod;
  int? decimalpoints;
  int? questiondecimalpoints;
  int? sumgrades;
  int? grade;
  int? hasfeedback;
  int? section;
  int? visible;
  int? groupmode;
  int? groupingid;

  Quiz(
      {this.id,
      this.course,
      this.coursemodule,
      this.name,
      this.intro,
      this.introformat,
      this.timeopen,
      this.timeclose,
      this.timelimit,
      this.preferredbehaviour,
      this.attempts,
      this.grademethod,
      this.decimalpoints,
      this.questiondecimalpoints,
      this.sumgrades,
      this.grade,
      this.hasfeedback,
      this.section,
      this.visible,
      this.groupmode,
      this.groupingid});

  Quiz.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    course = json['course'];
    coursemodule = json['coursemodule'];
    name = json['name'];
    intro = json['intro'];
    introformat = json['introformat'];
    timeopen = json['timeopen'];
    timeclose = json['timeclose'];
    timelimit = json['timelimit'];
    preferredbehaviour = json['preferredbehaviour'];
    attempts = json['attempts'];
    grademethod = json['grademethod'];
    decimalpoints = json['decimalpoints'];
    questiondecimalpoints = json['questiondecimalpoints'];
    sumgrades = json['sumgrades'];
    grade = json['grade'];
    hasfeedback = json['hasfeedback'];
    section = json['section'];
    visible = json['visible'];
    groupmode = json['groupmode'];
    groupingid = json['groupingid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['course'] = this.course;
    data['coursemodule'] = this.coursemodule;
    data['name'] = this.name;
    data['intro'] = this.intro;
    data['introformat'] = this.introformat;
    data['timeopen'] = this.timeopen;
    data['timeclose'] = this.timeclose;
    data['timelimit'] = this.timelimit;
    data['preferredbehaviour'] = this.preferredbehaviour;
    data['attempts'] = this.attempts;
    data['grademethod'] = this.grademethod;
    data['decimalpoints'] = this.decimalpoints;
    data['questiondecimalpoints'] = this.questiondecimalpoints;
    data['sumgrades'] = this.sumgrades;
    data['grade'] = this.grade;
    data['hasfeedback'] = this.hasfeedback;
    data['section'] = this.section;
    data['visible'] = this.visible;
    data['groupmode'] = this.groupmode;
    data['groupingid'] = this.groupingid;
    return data;
  }
}
