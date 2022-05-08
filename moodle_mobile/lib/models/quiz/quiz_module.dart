class QuizModule {
  int? id;
  String? url;
  String? name;
  int? instance;
  int? contextid;
  int? visible;
  bool? uservisible;
  int? visibleoncoursepage;
  String? modicon;
  String? modname;
  String? modplural;
  int? indent;
  String? onclick;
  String? customdata;
  bool? noviewlink;
  int? completion;
  Completiondata? completiondata;
  List<Dates>? dates;

  QuizModule(
      {this.id,
      this.url,
      this.name,
      this.instance,
      this.contextid,
      this.visible,
      this.uservisible,
      this.visibleoncoursepage,
      this.modicon,
      this.modname,
      this.modplural,
      this.indent,
      this.onclick,
      this.customdata,
      this.noviewlink,
      this.completion,
      this.completiondata,
      this.dates});

  QuizModule.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    name = json['name'];
    instance = json['instance'];
    contextid = json['contextid'];
    visible = json['visible'];
    uservisible = json['uservisible'];
    visibleoncoursepage = json['visibleoncoursepage'];
    modicon = json['modicon'];
    modname = json['modname'];
    modplural = json['modplural'];
    indent = json['indent'];
    onclick = json['onclick'];
    customdata = json['customdata'];
    noviewlink = json['noviewlink'];
    completion = json['completion'];
    completiondata = json['completiondata'] != null
        ? new Completiondata.fromJson(json['completiondata'])
        : null;
    if (json['dates'] != null) {
      dates = [];
      json['dates'].forEach((v) {
        dates!.add(Dates.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['url'] = url;
    data['name'] = name;
    data['instance'] = instance;
    data['contextid'] = contextid;
    data['visible'] = visible;
    data['uservisible'] = uservisible;
    data['visibleoncoursepage'] = visibleoncoursepage;
    data['modicon'] = modicon;
    data['modname'] = modname;
    data['modplural'] = modplural;
    data['indent'] = indent;
    data['onclick'] = onclick;
    data['customdata'] = customdata;
    data['noviewlink'] = noviewlink;
    data['completion'] = completion;
    if (completiondata != null) {
      data['completiondata'] = completiondata!.toJson();
    }
    if (dates != null) {
      data['dates'] = dates!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Completiondata {
  int? state;
  int? timecompleted;
  dynamic overrideby;
  bool? valueused;
  bool? hascompletion;
  bool? isautomatic;
  bool? istrackeduser;
  bool? uservisible;

  Completiondata({
    this.state,
    this.timecompleted,
    this.overrideby,
    this.valueused,
    this.hascompletion,
    this.isautomatic,
    this.istrackeduser,
    this.uservisible,
  });

  Completiondata.fromJson(Map<String, dynamic> json) {
    state = json['state'];
    timecompleted = json['timecompleted'];
    overrideby = json['overrideby'];
    valueused = json['valueused'];
    hascompletion = json['hascompletion'];
    isautomatic = json['isautomatic'];
    istrackeduser = json['istrackeduser'];
    uservisible = json['uservisible'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['state'] = state;
    data['timecompleted'] = timecompleted;
    data['overrideby'] = overrideby;
    data['valueused'] = valueused;
    data['hascompletion'] = hascompletion;
    data['isautomatic'] = isautomatic;
    data['istrackeduser'] = istrackeduser;
    data['uservisible'] = uservisible;
    return data;
  }
}

class Dates {
  String? label;
  int? timestamp;

  Dates({this.label, this.timestamp});

  Dates.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = label;
    data['timestamp'] = timestamp;
    return data;
  }
}