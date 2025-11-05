import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workstation_flutter/auth/data/auth_service.dart';
import 'package:workstation_flutter/auth/presentation/blocs/login_blocs/login_bloc.dart';
import 'package:workstation_flutter/auth/presentation/pages/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workstation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8BC34A)),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => LoginBloc(
          service: AuthService(), 
        ),
        child: const LoginPage(),
      ),
    );
  }
}
