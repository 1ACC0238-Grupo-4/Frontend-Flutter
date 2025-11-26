import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workstation_flutter/auth/presentation/blocs/login_blocs/auth_bloc.dart';
import 'package:workstation_flutter/auth/presentation/blocs/login_blocs/auth_state.dart';
import 'package:workstation_flutter/auth/presentation/pages/login_page.dart';
import 'package:workstation_flutter/auth/presentation/widgets/main_navigator.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        switch (state.status) {
          case AuthStatus.unauthenticated:
            return const Scaffold(body: LoginPage());
          case AuthStatus.authenticated:
            return const MainNavigation();
          default:
            return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }
}