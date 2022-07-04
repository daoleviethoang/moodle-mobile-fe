class MessageContact {
  int? id;
  String? fullname;
  String? profileurl;
  String? profileimageurl;
  String? profileimageurlsmall;
  bool? showonlinestatus;
  bool? isblocked;
  bool? iscontact;
  bool? isdeleted;
  List<Conversations>? conversations;

  MessageContact(
      {this.id,
      this.fullname,
      this.profileurl,
      this.profileimageurl,
      this.profileimageurlsmall,
      this.showonlinestatus,
      this.isblocked,
      this.iscontact,
      this.isdeleted,
      this.conversations});

  MessageContact.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullname = json['fullname'];
    profileurl = json['profileurl'];
    profileimageurl = json['profileimageurl'];
    profileimageurlsmall = json['profileimageurlsmall'];
    showonlinestatus = json['showonlinestatus'];
    isblocked = json['isblocked'];
    iscontact = json['iscontact'];
    isdeleted = json['isdeleted'];
    if (json['conversations'] != null) {
      conversations = [];
      json['conversations'].forEach((v) {
        conversations!.add(Conversations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['fullname'] = fullname;
    data['profileurl'] = profileurl;
    data['profileimageurl'] = profileimageurl;
    data['profileimageurlsmall'] = profileimageurlsmall;
    data['showonlinestatus'] = showonlinestatus;
    data['isblocked'] = isblocked;
    data['iscontact'] = iscontact;
    data['isdeleted'] = isdeleted;
    if (conversations != null) {
      data['conversations'] = conversations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Conversations {
  int? id;
  int? type;
  int? timecreated;

  Conversations({this.id, this.type, this.timecreated});

  Conversations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    timecreated = json['timecreated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['type'] = type;
    data['timecreated'] = timecreated;
    return data;
  }
}
