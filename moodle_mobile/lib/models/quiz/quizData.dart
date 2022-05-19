import 'package:moodle_mobile/models/quiz/question.dart';

class QuizData {
  double? grade;
  AttemptData? attempt;
  int? nextpage;
  List<Question>? questions;

  QuizData({
    this.grade,
    this.attempt,
    this.nextpage,
    this.questions,
  });

  QuizData.fromJson(Map<String, dynamic> json) {
    grade = json['grade'];
    nextpage = json["nextpage"];
    attempt = json['attempt'] != null
        ? new AttemptData.fromJson(json['attempt'])
        : null;
    if (json['questions'] != null) {
      questions = [];
      json['questions'].forEach((v) {
        questions!.add(new Question.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['grade'] = this.grade;
    data['nextpage'] = this.nextpage;
    if (this.attempt != null) {
      data['attempt'] = this.attempt!.toJson();
    }
    if (this.questions != null) {
      data['questions'] = this.questions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AttemptData {
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

  AttemptData(
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

  AttemptData.fromJson(Map<String, dynamic> json) {
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
    sumgrades = json['sumgrades'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['quiz'] = this.quiz;
    data['userid'] = this.userid;
    data['attempt'] = this.attempt;
    data['uniqueid'] = this.uniqueid;
    data['layout'] = this.layout;
    data['currentpage'] = this.currentpage;
    data['preview'] = this.preview;
    data['state'] = this.state;
    data['timestart'] = this.timestart;
    data['timefinish'] = this.timefinish;
    data['timemodified'] = this.timemodified;
    data['timemodifiedoffline'] = this.timemodifiedoffline;
    data['sumgrades'] = this.sumgrades;
    return data;
  }
}
