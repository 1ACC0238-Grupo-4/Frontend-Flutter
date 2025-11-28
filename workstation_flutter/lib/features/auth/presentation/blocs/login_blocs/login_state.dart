import 'package:workstation_flutter/core/enums/status.dart';

class LoginState{
  final Status status;
  final String email;
  final String password;
  final String? errorMessage;
  const LoginState({
    this.status = Status.initial,
    this.email = '',
    this.password = '',
    this.errorMessage,
  });

  LoginState copyWith({
    Status? status,
    String? email,
    String? password,
    String? errorMessage,
  }){
    return LoginState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      errorMessage: errorMessage ?? this.errorMessage,
    );

  }
}