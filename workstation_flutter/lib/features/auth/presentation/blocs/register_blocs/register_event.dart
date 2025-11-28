abstract class RegisterEvent {
  const RegisterEvent();
}

class Register extends RegisterEvent{
  const Register();
}

class OnFirstNameChanged extends RegisterEvent{
 final String firstName;
 const OnFirstNameChanged({required this.firstName});
}

class OnLastNameChanged extends RegisterEvent{
 final String lastName;
 const OnLastNameChanged({required this.lastName});
}

class OnDniChanged extends RegisterEvent{
  final String dni;
  const OnDniChanged({required this.dni});
}

class OnPhoneNumberChanged extends RegisterEvent{
  final String phoneNumber;
  const OnPhoneNumberChanged({required this.phoneNumber});
}

class OnEmailChanged extends RegisterEvent{
   final String email;
   const OnEmailChanged({required this.email});
}

class OnPasswordChanged extends RegisterEvent{
  final String password;
  const OnPasswordChanged({required this.password});
}

class OnRoleChanged extends RegisterEvent{
  final int role;
  const OnRoleChanged({required this.role});
}

