import 'dart:convert';

class Post {
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
  Null? wordcount;
  Null? charcount;
  Map<String, bool>? capabilities;
  Map<String, String>? urls;
  List<Null>? attachments;
  List<Null>? tags;
  Map<String, dynamic>? html;

  Post(
      {this.id,
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
      this.capabilities,
      this.urls,
      this.attachments,
      this.tags,
      this.html});

  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subject = json['subject'];
    replysubject = json['replysubject'];
    message = json['message'];
    messageformat = json['messageformat'];
    author =
        json['author'] != null ? new Author.fromJson(json['author']) : null;
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
    capabilities = jsonDecode(json['capabilities']);
    urls = jsonDecode(json['urls']);
    if (json['attachments'] != null) {
      attachments = <Null>[];
      json['attachments'].forEach((v) {
        attachments!.add(new Null.fromJson(v));
      });
    }
    if (json['tags'] != null) {
      tags = <Null>[];
      json['tags'].forEach((v) {
        tags!.add(new Null.fromJson(v));
      });
    }
    html = json['html'] != null ? new Html.fromJson(json['html']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subject'] = this.subject;
    data['replysubject'] = this.replysubject;
    data['message'] = this.message;
    data['messageformat'] = this.messageformat;
    if (this.author != null) {
      data['author'] = this.author!.toJson();
    }
    data['discussionid'] = this.discussionid;
    data['hasparent'] = this.hasparent;
    data['parentid'] = this.parentid;
    data['timecreated'] = this.timecreated;
    data['timemodified'] = this.timemodified;
    data['unread'] = this.unread;
    data['isdeleted'] = this.isdeleted;
    data['isprivatereply'] = this.isprivatereply;
    data['haswordcount'] = this.haswordcount;
    data['wordcount'] = this.wordcount;
    data['charcount'] = this.charcount;
    if (this.capabilities != null) {
      data['capabilities'] = jsonEncode(this.capabilities);
    }
    if (this.urls != null) {
      data['urls'] = jsonEncode(this.urls);
    }
    if (this.attachments != null) {
      data['attachments'] = this.attachments!.map((v) => v.toJson()).toList();
    }
    if (this.tags != null) {
      data['tags'] = this.tags!.map((v) => v.toJson()).toList();
    }
    if (this.html != null) {
      data['html'] = this.html!.toJson();
    }
    return data;
  }
}

class Author {
  int? id;
  String? fullname;
  bool? isdeleted;
  List<Null>? groups;
  Urls? urls;

  Author({this.id, this.fullname, this.isdeleted, this.groups, this.urls});

  Author.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullname = json['fullname'];
    isdeleted = json['isdeleted'];
    if (json['groups'] != null) {
      groups = <Null>[];
      json['groups'].forEach((v) {
        groups!.add(new Null.fromJson(v));
      });
    }
    urls = json['urls'] != null ? new Urls.fromJson(json['urls']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fullname'] = this.fullname;
    data['isdeleted'] = this.isdeleted;
    if (this.groups != null) {
      data['groups'] = this.groups!.map((v) => v.toJson()).toList();
    }
    if (this.urls != null) {
      data['urls'] = this.urls!.toJson();
    }
    return data;
  }
}
