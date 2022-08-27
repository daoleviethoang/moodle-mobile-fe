class AttemptUser {
  int? id;
  int? userid;
  double? sumgrades;
  String? state;
  int? timestart;
  int? timefinish;

  AttemptUser(
      {this.id,
      this.userid,
      this.sumgrades,
      this.state,
      this.timestart,
      this.timefinish});

  AttemptUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    sumgrades = json['sumgrades'] is int
        ? (json['sumgrades'] as int).toDouble()
        : json['sumgrades'];
    state = json['state'];
    timestart = json['timestart'];
    timefinish = json['timefinish'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userid'] = userid;
    data['sumgrades'] = sumgrades;
    data['state'] = state;
    data['timestart'] = timestart;
    data['timefinish'] = timefinish;
    return data;
  }
}
