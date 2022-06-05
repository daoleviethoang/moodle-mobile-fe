class UserLogin {
  String token;
  String username;
  String baseUrl;
  String? photo;

  UserLogin({
    required this.token,
    this.photo,
    required this.baseUrl,
    required this.username,
  });

  static UserLogin fromJson(Map<String, dynamic> json) {
    return UserLogin(
      token: json['token'] as String,
      baseUrl: json['baseUrl'] as String,
      username: json['username'] as String,
      photo: json['photo'] as String?,
    );
  }
}
