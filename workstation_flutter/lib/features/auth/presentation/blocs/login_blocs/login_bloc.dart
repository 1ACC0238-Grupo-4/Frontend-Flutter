import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workstation_flutter/features/auth/data/auth_service.dart';
import 'package:workstation_flutter/features/auth/presentation/blocs/login_blocs/login_event.dart';
import 'package:workstation_flutter/features/auth/presentation/blocs/login_blocs/login_state.dart';
import 'package:workstation_flutter/core/enums/status.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthService service;
  
  LoginBloc({required this.service}) : super(LoginState()) {
    on<OnEmailChanged>(
      (event, emit) => emit(state.copyWith(email: event.email))
    );
    
    on<OnPasswordChanged>(
      (event, emit) => emit(state.copyWith(password: event.password)),
    );
    
    on<Login>(_onLogin);
  }

  FutureOr<void> _onLogin(Login event, Emitter<LoginState> emit) async {
    if (state.email.isEmpty || state.password.isEmpty) {
      emit(state.copyWith(
        status: Status.failure,
        errorMessage: 'Por favor completa todos los campos',
      ));
      return;
    }

    emit(state.copyWith(status: Status.loading));
    
    try {
      await service.login(state.email, state.password);
      emit(state.copyWith(status: Status.success));
    } on SocketException catch (e) {
      emit(state.copyWith(
        status: Status.failure,
        errorMessage: 'No hay conexión a internet. Verifica tu red.',
      ));
    } on TimeoutException catch (e) {
 
      emit(state.copyWith(
        status: Status.failure,
        errorMessage: 'La solicitud tardó demasiado. Intenta nuevamente.',
      ));
    } on FormatException catch (e) {

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

  String _parseErrorMessage(String error) {
    if (error.contains('401') || error.contains('Unauthorized')) {
      return 'Credenciales incorrectas. Verifica tu email y contraseña.';
    }
    
    if (error.contains('404') || error.contains('Not Found')) {
      return 'Usuario no encontrado. Verifica tu email.';
    }
    
    if (error.contains('403') || error.contains('Forbidden')) {
      return 'Acceso denegado. Tu cuenta puede estar desactivada.';
    }
    
    if (error.contains('500') || error.contains('Internal Server Error')) {
      return 'Error del servidor. Intenta más tarde.';
    }
    
    if (error.contains('400') || error.contains('Bad Request')) {
      return 'Datos inválidos. Verifica tu información.';
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

    if (error.contains('password') && error.contains('incorrect')) {
      return 'Contraseña incorrecta.';
    }

    if (error.contains('Exception:')) {
      return error.replaceAll('Exception:', '').trim();
    }
    
    return 'Error al iniciar sesión: ${error.length > 100 ? '${error.substring(0, 100)}...' : error}';
  }
}