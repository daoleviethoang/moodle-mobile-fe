class UserQuizz {
  int? id;
  String? firstname;
  String? lastname;
  String? fullname;
  String? email;
  int? firstaccess;
  int? lastaccess;
  bool? suspended;
  String? description;
  int? descriptionformat;
  String? city;
  String? country;
  String? profileimageurlsmall;
  String? profileimageurl;
  double? grade;
  int? attempId;

  UserQuizz(
      {this.id,
      this.firstname,
      this.lastname,
      this.fullname,
      this.email,
      this.firstaccess,
      this.lastaccess,
      this.suspended,
      this.description,
      this.descriptionformat,
      this.city,
      this.country,
      this.profileimageurlsmall,
      this.profileimageurl,
      this.grade,
      this.attempId});

  UserQuizz.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    fullname = json['fullname'];
    email = json['email'];
    firstaccess = json['firstaccess'];
    lastaccess = json['lastaccess'];
    suspended = json['suspended'];
    description = json['description'];
    descriptionformat = json['descriptionformat'];
    city = json['city'];
    country = json['country'];
    profileimageurlsmall = json['profileimageurlsmall'];
    profileimageurl = json['profileimageurl'];
    grade = json['grade'];
    attempId = json['attempId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['fullname'] = this.fullname;
    data['email'] = this.email;
    data['firstaccess'] = this.firstaccess;
    data['lastaccess'] = this.lastaccess;
    data['suspended'] = this.suspended;
    data['description'] = this.description;
    data['descriptionformat'] = this.descriptionformat;
    data['city'] = this.city;
    data['country'] = this.country;
    data['profileimageurlsmall'] = this.profileimageurlsmall;
    data['profileimageurl'] = this.profileimageurl;
    data['grade'] = this.grade;
    data['attempId'] = this.attempId;
    return data;
  }
}
