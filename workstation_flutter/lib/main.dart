import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:workstation_flutter/core/storage/auth_repository.dart';
import 'package:workstation_flutter/core/storage/token_storage.dart';
import 'package:workstation_flutter/features/auth/data/auth_service.dart';
import 'package:workstation_flutter/features/auth/presentation/blocs/login_blocs/auth_bloc.dart';
import 'package:workstation_flutter/features/auth/presentation/blocs/login_blocs/auth_event.dart';
import 'package:workstation_flutter/features/auth/presentation/blocs/login_blocs/login_bloc.dart';
import 'package:workstation_flutter/features/auth/presentation/blocs/register_blocs/register_bloc.dart';
import 'package:workstation_flutter/features/auth/presentation/pages/splash_page.dart';
import 'package:workstation_flutter/features/contract/data/contacts_service.dart';
import 'package:workstation_flutter/features/contract/presentation/blocs/contract_bloc.dart';
import 'package:workstation_flutter/features/search/data/offices_service.dart';
import 'package:workstation_flutter/features/search/presentation/blocs/search_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final tokenStorage = TokenStorage(); // Crea instancia de TokenStorage
    final authRepository = AuthRepository(tokenStorage); // Pasa TokenStorage a AuthRepository
    final officeService = OfficeAPIService();
    final contractService = ContractAPIService();
    
    return MultiProvider(
      providers: [
        // Provider para TokenStorage (por si otras partes lo necesitan)
        Provider<TokenStorage>.value(value: tokenStorage),
        
        // Provider para AuthRepository con su dependencia
        Provider<AuthRepository>.value(value: authRepository),
        
        // Tus BlocProviders existentes
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
        BlocProvider(
          create: (context) => ContractBloc(contractService: contractService),
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