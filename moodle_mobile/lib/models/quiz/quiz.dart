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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['course'] = course;
    data['coursemodule'] = coursemodule;
    data['name'] = name;
    data['intro'] = intro;
    data['introformat'] = introformat;
    data['timeopen'] = timeopen;
    data['timeclose'] = timeclose;
    data['timelimit'] = timelimit;
    data['preferredbehaviour'] = preferredbehaviour;
    data['attempts'] = attempts;
    data['grademethod'] = grademethod;
    data['decimalpoints'] = decimalpoints;
    data['questiondecimalpoints'] = questiondecimalpoints;
    data['sumgrades'] = sumgrades;
    data['grade'] = grade;
    data['hasfeedback'] = hasfeedback;
    data['section'] = section;
    data['visible'] = visible;
    data['groupmode'] = groupmode;
    data['groupingid'] = groupingid;
    return data;
  }
}