import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workstation_flutter/features/auth/data/auth_service.dart';
import 'package:workstation_flutter/features/auth/presentation/blocs/register_blocs/register_event.dart';
import 'package:workstation_flutter/features/auth/presentation/blocs/register_blocs/register_state.dart';
import 'package:workstation_flutter/core/enums/status.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthService service;
  
  RegisterBloc({required this.service}) : super(RegisterState()) {
    on<OnFirstNameChanged>(
      (event, emit) => emit(state.copyWith(firstName: event.firstName))
    );
    
    on<OnLastNameChanged>(
      (event, emit) => emit(state.copyWith(lastName: event.lastName))
    );
    
    on<OnDniChanged>(
      (event, emit) => emit(state.copyWith(dni: event.dni))
    );
    
    on<OnPhoneNumberChanged>(
      (event, emit) => emit(state.copyWith(phoneNumber: event.phoneNumber))
    );
    
    on<OnEmailChanged>(
      (event, emit) => emit(state.copyWith(email: event.email))
    );
    
    on<OnPasswordChanged>(
      (event, emit) => emit(state.copyWith(password: event.password))
    );
    
    on<OnRoleChanged>(
      (event, emit) => emit(state.copyWith(role: event.role))
    );
    
    on<Register>(_onRegister);
  }

  FutureOr<void> _onRegister(Register event, Emitter<RegisterState> emit) async {
    final validationError = _validateFields();
    if (validationError != null) {
      emit(state.copyWith(
        status: Status.failure,
        errorMessage: validationError,
      ));
      return;
    }

    emit(state.copyWith(status: Status.loading));
    
    try {
      await service.register(
        state.firstName,
        state.lastName,
        state.dni,
        state.phoneNumber,
        state.email,
        state.password,
        state.role,
      );
      
      emit(state.copyWith(status: Status.success));
    } on SocketException {
      emit(state.copyWith(
        status: Status.failure,
        errorMessage: 'No hay conexión a internet. Verifica tu red.',
      ));
    } on TimeoutException {
      emit(state.copyWith(
        status: Status.failure,
        errorMessage: 'La solicitud tardó demasiado. Intenta nuevamente.',
      ));
    } on FormatException {
      emit(state.copyWith(
        status: Status.failure,
        errorMessage: 'Error en el formato de datos. Contacta soporte.',
      ));
    } on HttpException catch (e) {
      emit(state.copyWith(
        status: Status.failure,
        errorMessage: 'Error del servidor: ${e.message}',
      ));
    } catch (e) {
      
      String errorMessage = _parseErrorMessage(e.toString());
      
      emit(state.copyWith(
        status: Status.failure,
        errorMessage: errorMessage,
      ));
    }
  }

  String? _validateFields() {
    if (state.firstName.isEmpty) {
      return 'El nombre es obligatorio';
    }
    
    if (state.lastName.isEmpty) {
      return 'El apellido es obligatorio';
    }
    
    if (state.dni.isEmpty) {
      return 'El DNI es obligatorio';
    }
    
    if (state.dni.length < 8) {
      return 'El DNI debe tener al menos 8 dígitos';
    }
    
    if (state.phoneNumber.isEmpty) {
      return 'El número de teléfono es obligatorio';
    }
    
    if (state.phoneNumber.length < 9) {
      return 'El número de teléfono debe tener al menos 9 dígitos';
    }
    
    if (state.email.isEmpty) {
      return 'El email es obligatorio';
    }
    
    if (!state.email.contains('@') || !state.email.contains('.')) {
      return 'El email no es válido';
    }
    
    if (state.password.isEmpty) {
      return 'La contraseña es obligatoria';
    }
    
    if (state.password.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null; 
  }

  String _parseErrorMessage(String error) {
    if (error.contains('409') || error.contains('Conflict')) {
      return 'Este email ya está registrado. Intenta iniciar sesión.';
    }
    
    if (error.contains('email') && error.contains('exists')) {
      return 'Este email ya está en uso.';
    }
    
    if (error.contains('dni') && error.contains('exists')) {
      return 'Este DNI ya está registrado.';
    }
    
    if (error.contains('400') || error.contains('Bad Request')) {
      return 'Datos inválidos. Verifica tu información.';
    }
    
    if (error.contains('500') || error.contains('Internal Server Error')) {
      return 'Error del servidor. Intenta más tarde.';
    }
    
    if (error.contains('Network') || error.contains('network')) {
      return 'Error de red. Verifica tu conexión.';
    }
    
    if (error.contains('timeout') || error.contains('Timeout')) {
      return 'Tiempo de espera agotado. Intenta nuevamente.';
    }

    if (error.contains('email') && error.contains('invalid')) {
      return 'El formato del email no es válido.';
    }

    if (error.contains('password') && error.contains('weak')) {
      return 'La contraseña es muy débil. Usa letras y números.';
    }

    if (error.contains('Exception:')) {
      return error.replaceAll('Exception:', '').trim();
    }
    
    return 'Error al registrarse: ${error.length > 100 ? '${error.substring(0, 100)}...' : error}';
  }
}