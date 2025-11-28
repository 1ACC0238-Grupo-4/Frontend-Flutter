import 'package:workstation_flutter/core/enums/status.dart';

class RegisterState {
  final Status status;
  final String firstName;
  final String lastName;
  final String dni;
  final String phoneNumber;
  final String email;
  final String password;
  final int role;
  final String? errorMessage;

  const RegisterState({
    this.status = Status.initial,
    this.firstName = '',
    this.lastName = '',
    this.dni = '',
    this.phoneNumber = '',
    this.email = '',
    this.password = '',
    this.role = 0,
    this.errorMessage,
  });

  RegisterState copyWith({
    Status? status,
    String? firstName,
    String? lastName,
    String? dni,
    String? phoneNumber,
    String? email,
    String? password,
    int? role,
    String? errorMessage,
  }){
    return RegisterState(
      status: status ?? this.status,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dni: dni ?? this.dni,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      errorMessage: errorMessage ?? this.errorMessage
    );
  }


}
