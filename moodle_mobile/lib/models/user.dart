class UserModel {
  String token;
  int id;
  String username;
  String fullname;
  String email;

  UserModel(
      {required this.token,
      required this.id,
      required this.username,
      required this.fullname,
      required this.email});
}
