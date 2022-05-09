import 'package:moodle_mobile/view/common/content_item.dart';

class ForumDiscussion {
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
  //List<Attac>? attachments;
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

  ForumDiscussion(
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
      //this.attachments,
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

  ForumDiscussion.fromJson(Map<String, dynamic> json) {
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
    // if (json['attachments'] != null) {
    //   attachments = <Attachments>[];
    //   json['attachments'].forEach((v) {
    //     attachments!.add(new Attachments.fromJson(v));
    //   });
    // }
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['groupid'] = this.groupid;
    data['timemodified'] = this.timemodified;
    data['usermodified'] = this.usermodified;
    data['timestart'] = this.timestart;
    data['timeend'] = this.timeend;
    data['discussion'] = this.discussion;
    data['parent'] = this.parent;
    data['userid'] = this.userid;
    data['created'] = this.created;
    data['modified'] = this.modified;
    data['mailed'] = this.mailed;
    data['subject'] = this.subject;
    data['message'] = this.message;
    data['messageformat'] = this.messageformat;
    data['messagetrust'] = this.messagetrust;
    data['attachment'] = this.attachment;
    // if (this.attachments != null) {
    //   data['attachments'] = this.attachments!.map((v) => v.toJson()).toList();
    // }
    data['totalscore'] = this.totalscore;
    data['mailnow'] = this.mailnow;
    data['userfullname'] = this.userfullname;
    data['usermodifiedfullname'] = this.usermodifiedfullname;
    data['userpictureurl'] = this.userpictureurl;
    data['usermodifiedpictureurl'] = this.usermodifiedpictureurl;
    data['numreplies'] = this.numreplies;
    data['numunread'] = this.numunread;
    data['pinned'] = this.pinned;
    data['locked'] = this.locked;
    data['starred'] = this.starred;
    data['canreply'] = this.canreply;
    data['canlock'] = this.canlock;
    data['canfavourite'] = this.canfavourite;
    return data;
  }
}
