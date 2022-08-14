class CourseParticipantsModel {
  int id;
  String fullname;
  List<RoleOfParticitpants> roles;
  String avatar;
  int lastAccess;
  CourseParticipantsModel({
    required this.id,
    required this.fullname,
    required this.roles,
    required this.avatar,
    required this.lastAccess,
  });
}

class RoleOfParticitpants {
  int roleID;
  RoleOfParticitpants({required this.roleID});
}
