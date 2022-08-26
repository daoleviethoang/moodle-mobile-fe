class Question {
  int? slot;
  String? type;
  int? page;
  String? html;
  int? sequencecheck;
  int? lastactiontime;
  bool? hasautosavedstep;
  bool? flagged;
  int? number;
  String? status;
  bool? blockedbyprevious;
  String? mark;
  int? maxmark;
  String? settings;

  Question(
      {this.slot,
      this.type,
      this.page,
      this.html,
      this.sequencecheck,
      this.lastactiontime,
      this.hasautosavedstep,
      this.flagged,
      this.number,
      this.status,
      this.blockedbyprevious,
      this.maxmark,
      this.mark,
      this.settings});

  Question.fromJson(Map<String, dynamic> json) {
    slot = json['slot'];
    type = json['type'];
    page = json['page'];
    html = json['html'];
    sequencecheck = json['sequencecheck'];
    lastactiontime = json['lastactiontime'];
    hasautosavedstep = json['hasautosavedstep'];
    flagged = json['flagged'];
    number = json['number'];
    status = json['status'];
    blockedbyprevious = json['blockedbyprevious'];
    maxmark = json['maxmark'];
    mark = json['mark'] == "0.00" ? "0" : json['mark'];
    settings = json['settings'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['slot'] = slot;
    data['type'] = type;
    data['page'] = page;
    data['html'] = html;
    data['sequencecheck'] = sequencecheck;
    data['lastactiontime'] = lastactiontime;
    data['hasautosavedstep'] = hasautosavedstep;
    data['flagged'] = flagged;
    data['number'] = number;
    data['status'] = status;
    data['blockedbyprevious'] = blockedbyprevious;
    data['maxmark'] = maxmark;
    data['mark'] = mark;
    data['settings'] = settings;
    return data;
  }
}
