class CourseParticipantsModel {
  int id;
  String fullname;
  List<RoleOfParticitpants> roles;
  String avatar;
  CourseParticipantsModel(
      {required this.id,
      required this.fullname,
      required this.roles,
      required this.avatar});
}

class RoleOfParticitpants {
  int roleID;
  RoleOfParticitpants({required this.roleID});
}
