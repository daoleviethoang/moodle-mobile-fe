class Comment {
  List<Comments>? comments;
  int? count;
  int? perpage;
  bool? canpost;

  Comment({this.comments, this.count, this.perpage, this.canpost});

  Comment.fromJson(Map<String, dynamic> json) {
    if (json['comments'] != null) {
      comments = [];
      json['comments'].forEach((v) {
        comments!.add(Comments.fromJson(v));
      });
    }
    count = json['count'];
    perpage = json['perpage'];
    canpost = json['canpost'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (comments != null) {
      data['comments'] = comments!.map((v) => v.toJson()).toList();
    }
    data['count'] = count;
    data['perpage'] = perpage;
    data['canpost'] = canpost;
    return data;
  }
}

class Comments {
  int? id;
  String? content;
  int? format;
  int? timecreated;
  String? strftimeformat;
  String? profileurl;
  String? fullname;
  String? time;
  String? avatar;
  int? userid;
  bool? delete;

  Comments(
      {this.id,
      this.content,
      this.format,
      this.timecreated,
      this.strftimeformat,
      this.profileurl,
      this.fullname,
      this.time,
      this.avatar,
      this.userid,
      this.delete});

  Comments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    format = json['format'];
    timecreated = json['timecreated'];
    strftimeformat = json['strftimeformat'];
    profileurl = json['profileurl'];
    fullname = json['fullname'];
    time = json['time'];
    avatar = json['avatar'];
    userid = json['userid'];
    delete = json['delete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['content'] = content;
    data['format'] = format;
    data['timecreated'] = timecreated;
    data['strftimeformat'] = strftimeformat;
    data['profileurl'] = profileurl;
    data['fullname'] = fullname;
    data['time'] = time;
    data['avatar'] = avatar;
    data['userid'] = userid;
    data['delete'] = delete;
    return data;
  }
}