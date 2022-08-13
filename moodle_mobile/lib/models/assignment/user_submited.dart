class UserSubmited {
  int? id;
  String? fullname;
  int? recordid;
  bool? submitted;
  bool? requiregrading;
  String? profileimageurl;

  UserSubmited({
    this.id,
    this.fullname,
    this.recordid,
    this.submitted,
    this.requiregrading,
    this.profileimageurl,
  });

  UserSubmited.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullname = json['fullname'];
    recordid = json['recordid'];
    submitted = json['submitted'];
    requiregrading = json['requiregrading'];
    profileimageurl = json['profileimageurl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['fullname'] = fullname;
    data['recordid'] = recordid;
    data['submitted'] = submitted;
    data['requiregrading'] = requiregrading;
    data['profileimageurl'] = profileimageurl;
    return data;
  }
}
