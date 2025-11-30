class UserResponse {
  final String id;
  final String firstName;
  final String lastName;
  final String dni;
  final String phoneNumber;
  final String email;
  final int role;
  final String password;

  UserResponse({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.dni,
    required this.phoneNumber,
    required this.email,
    required this.role,
    required this.password,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      dni: json['dni'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      role: json['role'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'dni': dni,
      'phoneNumber': phoneNumber,
      'email': email,
      'role': role,
      'password': password,
    };
  }
}
