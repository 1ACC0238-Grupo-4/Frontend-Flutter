import 'package:flutter/material.dart';
import 'shared/presentation/pages/login_page.dart';
void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});
  @override
  Widget build (BuildContext context){
    return MaterialApp(
      title: "Workstation Flutter App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}