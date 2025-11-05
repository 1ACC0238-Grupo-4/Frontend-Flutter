import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workstation_flutter/auth/data/auth_service.dart';
import 'package:workstation_flutter/auth/presentation/blocs/register_blocs/register_event.dart';
import 'package:workstation_flutter/auth/presentation/blocs/register_blocs/register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent,RegisterState> {
  final AuthService service;

  RegisterBloc({required this.service}) : super(RegisterState()){

    on<OnFirstNameChanged>(
      (event,emit) => emit(state.copyWith(firstName: event.firstName))
    );


  }


}
