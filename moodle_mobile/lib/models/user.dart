class UserModel {
  String token;
  int id;
  String username;
  String fullname;
  String email;
  String baseUrl;
  String? photo;
  String? city;
  String? country;
  String? description;

  UserModel(
      {required this.token,
      required this.baseUrl,
      required this.id,
      this.photo,
      required this.username,
      required this.fullname,
      required this.email,
      this.city,
      this.country,
      this.description});
}
