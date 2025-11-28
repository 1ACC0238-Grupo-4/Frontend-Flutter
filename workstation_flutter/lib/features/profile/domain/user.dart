class User {
  String firstName;
  String lastName;
  String dni;
  String phoneNumber;
  String email;
  String? profileImageUrl;

  User({
    required this.firstName,
    required this.lastName,
    required this.dni,
    required this.phoneNumber,
    required this.email,
    this.profileImageUrl,
  });

  String get fullName => '$firstName $lastName';
}