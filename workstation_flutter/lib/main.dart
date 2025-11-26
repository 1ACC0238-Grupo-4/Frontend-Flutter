import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workstation_flutter/auth/data/auth_service.dart';
import 'package:workstation_flutter/auth/presentation/blocs/login_blocs/auth_bloc.dart';
import 'package:workstation_flutter/auth/presentation/blocs/login_blocs/auth_event.dart';
import 'package:workstation_flutter/auth/presentation/blocs/login_blocs/login_bloc.dart';
import 'package:workstation_flutter/auth/presentation/blocs/register_blocs/register_bloc.dart';
import 'package:workstation_flutter/auth/presentation/pages/splash_page.dart';
import 'package:workstation_flutter/search/data/offices_service.dart';
import 'package:workstation_flutter/search/presentation/blocs/search_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final officeService = OfficeAPIService(); // 👈 agrega tu service aquí
    
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(service: authService),
        ),
        BlocProvider(
          create: (context) => RegisterBloc(service: authService),
        ),
        BlocProvider(create: (context) => AuthBloc()..add(const AppStarted())),
        BlocProvider(
          create: (context) => SearchBloc(officeService: officeService),
        ),
      ],
      child: MaterialApp(
        title: 'Workstation',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8BC34A)),
          useMaterial3: true,
        ),
        home: const SplashPage(),
      ),
    );
  }
}