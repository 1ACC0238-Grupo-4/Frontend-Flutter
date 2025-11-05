class UserLogin {
  final String? email;
  final String? password;
  final String token;

  UserLogin({
    this.email,
    this.password,
    required this.token,
  });

  factory UserLogin.fromJson(dynamic json) {
    if (json is String) {
      return UserLogin(token: json);
    }

    return UserLogin(
      email: json['email'],
      password: json['passwordHash'],
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'passwordHash': password,
      'token': token,
    };
  }
}
