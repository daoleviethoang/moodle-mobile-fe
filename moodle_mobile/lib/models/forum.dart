class Forum {
  int? id;
  String? name;
  int? groupid;
  int? timemodified;
  int? usermodified;
  int? timestart;
  int? timeend;
  int? discussion;
  int? parent;
  int? userid;
  int? created;
  int? modified;
  int? mailed;
  String? subject;
  String? message;
  int? messageformat;
  int? messagetrust;
  bool? attachment;
  int? totalscore;
  int? mailnow;
  String? userfullname;
  String? usermodifiedfullname;
  String? userpictureurl;
  String? usermodifiedpictureurl;
  int? numreplies;
  int? numunread;
  bool? pinned;
  bool? locked;
  bool? starred;
  bool? canreply;
  bool? canlock;
  bool? canfavourite;

  Forum(
      {this.id,
      this.name,
      this.groupid,
      this.timemodified,
      this.usermodified,
      this.timestart,
      this.timeend,
      this.discussion,
      this.parent,
      this.userid,
      this.created,
      this.modified,
      this.mailed,
      this.subject,
      this.message,
      this.messageformat,
      this.messagetrust,
      this.attachment,
      this.totalscore,
      this.mailnow,
      this.userfullname,
      this.usermodifiedfullname,
      this.userpictureurl,
      this.usermodifiedpictureurl,
      this.numreplies,
      this.numunread,
      this.pinned,
      this.locked,
      this.starred,
      this.canreply,
      this.canlock,
      this.canfavourite});

  Forum.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    groupid = json['groupid'];
    timemodified = json['timemodified'];
    usermodified = json['usermodified'];
    timestart = json['timestart'];
    timeend = json['timeend'];
    discussion = json['discussion'];
    parent = json['parent'];
    userid = json['userid'];
    created = json['created'];
    modified = json['modified'];
    mailed = json['mailed'];
    subject = json['subject'];
    message = json['message'];
    messageformat = json['messageformat'];
    messagetrust = json['messagetrust'];
    attachment = json['attachment'];
    totalscore = json['totalscore'];
    mailnow = json['mailnow'];
    userfullname = json['userfullname'];
    usermodifiedfullname = json['usermodifiedfullname'];
    userpictureurl = json['userpictureurl'];
    usermodifiedpictureurl = json['usermodifiedpictureurl'];
    numreplies = json['numreplies'];
    numunread = json['numunread'];
    pinned = json['pinned'];
    locked = json['locked'];
    starred = json['starred'];
    canreply = json['canreply'];
    canlock = json['canlock'];
    canfavourite = json['canfavourite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['groupid'] = groupid;
    data['timemodified'] = timemodified;
    data['usermodified'] = usermodified;
    data['timestart'] = timestart;
    data['timeend'] = timeend;
    data['discussion'] = discussion;
    data['parent'] = parent;
    data['userid'] = userid;
    data['created'] = created;
    data['modified'] = modified;
    data['mailed'] = mailed;
    data['subject'] = subject;
    data['message'] = message;
    data['messageformat'] = messageformat;
    data['messagetrust'] = messagetrust;
    data['attachment'] = attachment;
    data['totalscore'] = totalscore;
    data['mailnow'] = mailnow;
    data['userfullname'] = userfullname;
    data['usermodifiedfullname'] = usermodifiedfullname;
    data['userpictureurl'] = userpictureurl;
    data['usermodifiedpictureurl'] = usermodifiedpictureurl;
    data['numreplies'] = numreplies;
    data['numunread'] = numunread;
    data['pinned'] = pinned;
    data['locked'] = locked;
    data['starred'] = starred;
    data['canreply'] = canreply;
    data['canlock'] = canlock;
    data['canfavourite'] = canfavourite;
    return data;
  }
}