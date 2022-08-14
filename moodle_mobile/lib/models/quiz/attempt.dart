class Attempt {
  int? id;
  int? quiz;
  int? userid;
  int? attempt;
  int? uniqueid;
  String? layout;
  int? currentpage;
  int? preview;
  String? state;
  int? timestart;
  int? timefinish;
  int? timemodified;
  int? timemodifiedoffline;
  double? sumgrades;

  Attempt(
      {this.id,
      this.quiz,
      this.userid,
      this.attempt,
      this.uniqueid,
      this.layout,
      this.currentpage,
      this.preview,
      this.state,
      this.timestart,
      this.timefinish,
      this.timemodified,
      this.timemodifiedoffline,
      this.sumgrades});

  Attempt.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quiz = json['quiz'];
    userid = json['userid'];
    attempt = json['attempt'];
    uniqueid = json['uniqueid'];
    layout = json['layout'];
    currentpage = json['currentpage'];
    preview = json['preview'];
    state = json['state'];
    timestart = json['timestart'];
    timefinish = json['timefinish'];
    timemodified = json['timemodified'];
    timemodifiedoffline = json['timemodifiedoffline'];
    sumgrades = json['sumgrades'] is int
        ? (json['sumgrades'] as int).toDouble()
        : json['sumgrades'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['quiz'] = quiz;
    data['userid'] = userid;
    data['attempt'] = attempt;
    data['uniqueid'] = uniqueid;
    data['layout'] = layout;
    data['currentpage'] = currentpage;
    data['preview'] = preview;
    data['state'] = state;
    data['timestart'] = timestart;
    data['timefinish'] = timefinish;
    data['timemodified'] = timemodified;
    data['timemodifiedoffline'] = timemodifiedoffline;
    data['sumgrades'] = sumgrades;
    return data;
  }
}