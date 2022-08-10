class UserSubmited {
  int? id;
  String? fullname;
  int? recordid;
  bool? submitted;
  bool? requiregrading;

  UserSubmited({
    this.id,
    this.fullname,
    this.recordid,
    this.submitted,
    this.requiregrading,
  });

  UserSubmited.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullname = json['fullname'];
    recordid = json['recordid'];
    submitted = json['submitted'];
    requiregrading = json['requiregrading'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['fullname'] = fullname;
    data['recordid'] = recordid;
    data['submitted'] = submitted;
    data['requiregrading'] = requiregrading;
    return data;
  }
}
