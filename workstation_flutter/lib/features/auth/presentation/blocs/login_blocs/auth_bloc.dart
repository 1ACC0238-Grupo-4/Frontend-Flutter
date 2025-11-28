import 'package:workstation_flutter/features/auth/presentation/blocs/login_blocs/auth_event.dart';
import 'package:workstation_flutter/features/auth/presentation/blocs/login_blocs/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workstation_flutter/core/storage/token_storage.dart';



class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState()) {
    on<AppStarted>(_onAppStarted);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {

    final token = await TokenStorage().read();

    emit(
      state.copyWith(
        status: token != null
            ? AuthStatus.authenticated
            : AuthStatus.unauthenticated,
      ),
    );
  }
}