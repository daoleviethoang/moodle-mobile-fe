import 'package:moodle_mobile/models/forum/forum_attachment.dart';

class ForumPost {
  int? id;
  String? subject;
  String? replysubject;
  String? message;
  int? messageformat;
  Author? author;
  int? discussionid;
  bool? hasparent;
  int? parentid;
  int? timecreated;
  int? timemodified;
  Null? unread;
  bool? isdeleted;
  bool? isprivatereply;
  bool? haswordcount;
  int? wordcount;
  int? charcount;
  //Capabilities? capabilities;
  //Urls? urls;
  List<ForumAttachment>? attachments;
  List<Null>? tags;
  //Html? htm
  //l;

  ForumPost({
    this.id,
    this.subject,
    this.replysubject,
    this.message,
    this.messageformat,
    this.author,
    this.discussionid,
    this.hasparent,
    this.parentid,
    this.timecreated,
    this.timemodified,
    this.unread,
    this.isdeleted,
    this.isprivatereply,
    this.haswordcount,
    this.wordcount,
    this.charcount,
    //this.capabilities,
    // this.urls,
    this.attachments,
    this.tags,
    //this.html
  });

  ForumPost.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subject = json['subject'];
    replysubject = json['replysubject'];
    message = json['message'];
    messageformat = json['messageformat'];
    author =
        json['author'] != null ? Author.fromJson(json['author']) : null;
    discussionid = json['discussionid'];
    hasparent = json['hasparent'];
    parentid = json['parentid'];
    timecreated = json['timecreated'];
    timemodified = json['timemodified'];
    unread = json['unread'];
    isdeleted = json['isdeleted'];
    isprivatereply = json['isprivatereply'];
    haswordcount = json['haswordcount'];
    wordcount = json['wordcount'];
    charcount = json['charcount'];
    // capabilities = json['capabilities'] != null
    //     ? new Capabilities.fromJson(json['capabilities'])
    //     : null;
    // urls = json['urls'] != null ? new Urls.fromJson(json['urls']) : null;
    if (json['attachments'] != null) {
      attachments = <ForumAttachment>[];
      json['attachments'].forEach((v) {
        attachments!.add(ForumAttachment.fromJson(v));
      });
      // }
      // if (json['tags'] != null) {
      //   tags = <Null>[];
      //   json['tags'].forEach((v) {
      //     tags!.add(new Null.fromJson(v));
      //   });
      // }
      //html = json['html'] != null ? new Html.fromJson(json['html']) : null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['subject'] = subject;
    data['replysubject'] = replysubject;
    data['message'] = message;
    data['messageformat'] = messageformat;
    if (author != null) {
      data['author'] = author!.toJson();
    }
    data['discussionid'] = discussionid;
    data['hasparent'] = hasparent;
    data['parentid'] = parentid;
    data['timecreated'] = timecreated;
    data['timemodified'] = timemodified;
    data['unread'] = unread;
    data['isdeleted'] = isdeleted;
    data['isprivatereply'] = isprivatereply;
    data['haswordcount'] = haswordcount;
    data['wordcount'] = wordcount;
    data['charcount'] = charcount;
    // if (this.capabilities != null) {
    //   data['capabilities'] = this.capabilities!.toJson();
    // }
    // if (this.urls != null) {
    //   data['urls'] = this.urls!.toJson();
    // }
    // if (this.attachments != null) {
    //   data['attachments'] = this.attachments!.map((v) => v.toJson()).toList();
    // }
    // if (this.tags != null) {
    //   data['tags'] = this.tags!.map((v) => v.toJson()).toList();
    // }
    // if (this.html != null) {
    //   data['html'] = this.html!.toJson();
    // }
    return data;
  }
}

class Author {
  int? id;
  String? fullname;
  bool? isdeleted;
  //List<Null>? groups;
  //Urls? urls;

  Author({
    this.id,
    this.fullname,
    this.isdeleted,
    //this.groups, this.urls
  });

  Author.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullname = json['fullname'];
    isdeleted = json['isdeleted'];
    // if (json['groups'] != null) {
    //   groups = <Null>[];
    //   json['groups'].forEach((v) {
    //     groups!.add(new Null.fromJson(v));
    //   });
    // }
    //urls = json['urls'] != null ? new Urls.fromJson(json['urls']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['fullname'] = fullname;
    data['isdeleted'] = isdeleted;
    // if (this.groups != null) {
    //   data['groups'] = this.groups!.map((v) => v.toJson()).toList();
    // }
    // if (this.urls != null) {
    //   data['urls'] = this.urls!.toJson();
    // }
    return data;
  }
}