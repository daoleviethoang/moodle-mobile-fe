class UserSubmited {
  int? id;
  String? fullname;
  int? recordid;
  bool? submitted;

  UserSubmited({
    this.id,
    this.fullname,
    this.recordid,
    this.submitted,
  });

  UserSubmited.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullname = json['fullname'];
    recordid = json['recordid'];
    submitted = json['submitted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['fullname'] = fullname;
    data['recordid'] = recordid;
    data['submitted'] = submitted;
    return data;
  }
}
