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
    grade = json['grade'] is int
        ? (json['grade'] as int).toDouble()
        : json['grade'];
    nextpage = json["nextpage"];
    attempt = json['attempt'] != null
        ? AttemptData.fromJson(json['attempt'])
        : null;
    if (json['questions'] != null) {
      questions = [];
      json['questions'].forEach((v) {
        questions!.add(Question.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['grade'] = grade;
    data['nextpage'] = nextpage;
    if (attempt != null) {
      data['attempt'] = attempt!.toJson();
    }
    if (questions != null) {
      data['questions'] = questions!.map((v) => v.toJson()).toList();
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