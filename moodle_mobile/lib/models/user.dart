class UserModel {
  String token;
  int id;
  String username;
  String fullname;
  String email;
  String baseUrl;
  String? photo;

  UserModel(
      {required this.token,
      required this.baseUrl,
      required this.id,
      this.photo,
      required this.username,
      required this.fullname,
      required this.email});
}
