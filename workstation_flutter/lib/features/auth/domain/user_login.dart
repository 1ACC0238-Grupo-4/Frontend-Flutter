class UserLogin {
  final String? email;
  final String? password;
  final String? token;
  
  UserLogin({
    this.email,
    this.password,
    this.token, 
  });
  
  factory UserLogin.fromJson(dynamic json) {
    return UserLogin(
      email: json['email'],
      password: json['passwordHash'],
      token: json['token'],
    );
  }
  
  factory UserLogin.fromToken(String token) {
    return UserLogin(
      token: token,
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