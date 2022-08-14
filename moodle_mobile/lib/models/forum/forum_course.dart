class ForumCourse {
  int? id;
  int? course;
  String? type;
  String? name;
  String? intro;
  int? duedate;
  int? cutoffdate;
  int? assessed;
  int? assesstimestart;
  int? assesstimefinish;
  int? scale;
  int? gradeForum;
  int? gradeForumNotify;
  int? maxbytes;
  int? maxattachments;
  int? forcesubscribe;
  int? trackingtype;
  int? rsstype;
  int? rssarticles;
  int? timemodified;
  int? warnafter;
  int? blockafter;
  int? blockperiod;
  int? completiondiscussions;
  int? completionreplies;
  int? completionposts;
  int? cmid;
  int? numdiscussions;
  bool? cancreatediscussions;
  int? lockdiscussionafter;
  bool? istracked;

  ForumCourse(
      {this.id,
      this.course,
      this.type,
      this.name,
      this.intro,
      this.duedate,
      this.cutoffdate,
      this.assessed,
      this.assesstimestart,
      this.assesstimefinish,
      this.scale,
      this.gradeForum,
      this.gradeForumNotify,
      this.maxbytes,
      this.maxattachments,
      this.forcesubscribe,
      this.trackingtype,
      this.rsstype,
      this.rssarticles,
      this.timemodified,
      this.warnafter,
      this.blockafter,
      this.blockperiod,
      this.completiondiscussions,
      this.completionreplies,
      this.completionposts,
      this.cmid,
      this.numdiscussions,
      this.cancreatediscussions,
      this.lockdiscussionafter,
      this.istracked});

  ForumCourse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    course = json['course'];
    type = json['type'];
    name = json['name'];
    intro = json['intro'];
    duedate = json['duedate'];
    cutoffdate = json['cutoffdate'];
    assessed = json['assessed'];
    assesstimestart = json['assesstimestart'];
    assesstimefinish = json['assesstimefinish'];
    scale = json['scale'];
    gradeForum = json['grade_forum'];
    gradeForumNotify = json['grade_forum_notify'];
    maxbytes = json['maxbytes'];
    maxattachments = json['maxattachments'];
    forcesubscribe = json['forcesubscribe'];
    trackingtype = json['trackingtype'];
    rsstype = json['rsstype'];
    rssarticles = json['rssarticles'];
    timemodified = json['timemodified'];
    warnafter = json['warnafter'];
    blockafter = json['blockafter'];
    blockperiod = json['blockperiod'];
    completiondiscussions = json['completiondiscussions'];
    completionreplies = json['completionreplies'];
    completionposts = json['completionposts'];
    cmid = json['cmid'];
    numdiscussions = json['numdiscussions'];
    cancreatediscussions = json['cancreatediscussions'];
    lockdiscussionafter = json['lockdiscussionafter'];
    istracked = json['istracked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['course'] = course;
    data['type'] = type;
    data['name'] = name;
    data['intro'] = intro;
    data['duedate'] = duedate;
    data['cutoffdate'] = cutoffdate;
    data['assessed'] = assessed;
    data['assesstimestart'] = assesstimestart;
    data['assesstimefinish'] = assesstimefinish;
    data['scale'] = scale;
    data['grade_forum'] = gradeForum;
    data['grade_forum_notify'] = gradeForumNotify;
    data['maxbytes'] = maxbytes;
    data['maxattachments'] = maxattachments;
    data['forcesubscribe'] = forcesubscribe;
    data['trackingtype'] = trackingtype;
    data['rsstype'] = rsstype;
    data['rssarticles'] = rssarticles;
    data['timemodified'] = timemodified;
    data['warnafter'] = warnafter;
    data['blockafter'] = blockafter;
    data['blockperiod'] = blockperiod;
    data['completiondiscussions'] = completiondiscussions;
    data['completionreplies'] = completionreplies;
    data['completionposts'] = completionposts;
    data['cmid'] = cmid;
    data['numdiscussions'] = numdiscussions;
    data['cancreatediscussions'] = cancreatediscussions;
    data['lockdiscussionafter'] = lockdiscussionafter;
    data['istracked'] = istracked;
    return data;
  }
}