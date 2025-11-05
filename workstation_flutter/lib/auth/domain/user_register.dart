class UserRegister {
  final String firstName;
  final String lastName;
  final String dni;
  final String phoneNumber;
  final String email;
  final String password;
  final int role;

  UserRegister({
    required this.firstName,
    required this.lastName,
    required this.dni,
    required this.phoneNumber,
    required this.email,
    required this.password,
    required this.role,

  });

  factory UserRegister.fromJson(Map<String, dynamic> json){
    return UserRegister(
      firstName: json['firstName'],
      lastName: json['lastName'],
      dni: json['dni'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      password: json['passwordHash'],
      role: json['role'],

    );
  }
    Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'dni': dni,
      'phoneNumber': phoneNumber,
      'email': email,
      'passwordHash': password,
      'role': role,
    };
  }
}