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
    grade = json['grade'] is int
        ? (json['grade'] as int).toDouble()
        : json['grade'];
    attempId = json['attempId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['fullname'] = fullname;
    data['email'] = email;
    data['firstaccess'] = firstaccess;
    data['lastaccess'] = lastaccess;
    data['suspended'] = suspended;
    data['description'] = description;
    data['descriptionformat'] = descriptionformat;
    data['city'] = city;
    data['country'] = country;
    data['profileimageurlsmall'] = profileimageurlsmall;
    data['profileimageurl'] = profileimageurl;
    data['grade'] = grade;
    data['attempId'] = attempId;
    return data;
  }
}
