class CourseOverView {
  int? id;
  String? shortname;
  String? fullname;
  String? displayname;
  int? enrolledusercount;
  String? idnumber;
  int? visible;
  String? summary;
  int? summaryformat;
  String? format;
  bool? showgrades;
  String? lang;
  bool? enablecompletion;
  bool? completionhascriteria;
  bool? completionusertracked;
  int? category;
  int? startdate;
  int? enddate;
  int? marker;
  int? lastaccess;
  bool? isfavourite;
  bool? hidden;
  bool? showactivitydates;
  bool? showcompletionconditions;

  CourseOverView(
      {this.id,
      this.shortname,
      this.fullname,
      this.displayname,
      this.enrolledusercount,
      this.idnumber,
      this.visible,
      this.summary,
      this.summaryformat,
      this.format,
      this.showgrades,
      this.lang,
      this.enablecompletion,
      this.completionhascriteria,
      this.completionusertracked,
      this.category,
      this.startdate,
      this.enddate,
      this.marker,
      this.lastaccess,
      this.isfavourite,
      this.hidden,
      this.showactivitydates,
      this.showcompletionconditions});

  CourseOverView.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shortname = json['shortname'];
    fullname = json['fullname'];
    displayname = json['displayname'];
    enrolledusercount = json['enrolledusercount'];
    idnumber = json['idnumber'];
    visible = json['visible'];
    summary = json['summary'];
    summaryformat = json['summaryformat'];
    format = json['format'];
    showgrades = json['showgrades'];
    lang = json['lang'];
    enablecompletion = json['enablecompletion'];
    completionhascriteria = json['completionhascriteria'];
    completionusertracked = json['completionusertracked'];
    category = json['category'];
    startdate = json['startdate'];
    enddate = json['enddate'];
    marker = json['marker'];
    lastaccess = json['lastaccess'];
    isfavourite = json['isfavourite'];
    hidden = json['hidden'];
    showactivitydates = json['showactivitydates'];
    showcompletionconditions = json['showcompletionconditions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['shortname'] = shortname;
    data['fullname'] = fullname;
    data['displayname'] = displayname;
    data['enrolledusercount'] = enrolledusercount;
    data['idnumber'] = idnumber;
    data['visible'] = visible;
    data['summary'] = summary;
    data['summaryformat'] = summaryformat;
    data['format'] = format;
    data['showgrades'] = showgrades;
    data['lang'] = lang;
    data['enablecompletion'] = enablecompletion;
    data['completionhascriteria'] = completionhascriteria;
    data['completionusertracked'] = completionusertracked;
    data['category'] = category;
    data['startdate'] = startdate;
    data['enddate'] = enddate;
    data['marker'] = marker;
    data['lastaccess'] = lastaccess;
    data['isfavourite'] = isfavourite;
    data['hidden'] = hidden;
    data['showactivitydates'] = showactivitydates;
    data['showcompletionconditions'] = showcompletionconditions;
    return data;
  }
}
