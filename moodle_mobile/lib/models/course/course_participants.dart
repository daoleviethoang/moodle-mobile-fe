class CourseParticipantsModel {
  int id;
  String fullname;
  List<RoleOfParticitpants> roles;
  CourseParticipantsModel(
      {required this.id, required this.fullname, required this.roles});
}

class RoleOfParticitpants {
  int roleID;
  RoleOfParticitpants({required this.roleID});
}
