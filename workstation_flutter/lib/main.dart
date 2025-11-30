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
import 'package:workstation_flutter/features/contract/presentation/blocs/contract_detail_bloc.dart';
import 'package:workstation_flutter/features/profile/data/user_service.dart';
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
    final tokenStorage = TokenStorage();
    final authRepository = AuthRepository(tokenStorage);
    final officeService = OfficeAPIService();
    final contractService = ContractAPIService();
    final userService = UserService();

    return MultiProvider(
      providers: [
        Provider<TokenStorage>.value(value: tokenStorage),

        Provider<AuthRepository>.value(value: authRepository),

        Provider<OfficeAPIService>.value(value: officeService),
        Provider<ContractAPIService>.value(value: contractService),
        Provider<UserService>.value(value: userService),

        BlocProvider(create: (context) => LoginBloc(service: authService)),
        BlocProvider(create: (context) => RegisterBloc(service: authService)),
        BlocProvider(create: (context) => AuthBloc()..add(const AppStarted())),
        BlocProvider(
          create: (context) => SearchBloc(officeService: officeService),
        ),
        BlocProvider(
          create: (context) => ContractBloc(contractService: contractService),
        ),

        BlocProvider(
          create: (context) => ContractDetailBloc(
            contractService: contractService,
            officeService: officeService,
            userService: userService,
          ),
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
