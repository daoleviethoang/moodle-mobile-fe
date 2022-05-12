class UserLogin {
  String token;
  String username;
  String baseUrl;

  UserLogin({
    required this.token,
    required this.baseUrl,
    required this.username,
  });

  static UserLogin fromJson(Map<String, dynamic> json) {
    return UserLogin(
      token: json['token'] as String,
      baseUrl: json['baseUrl'] as String,
      username: json['username'] as String,
    );
  }
}
