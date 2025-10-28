import 'package:flutter/material.dart';
import 'package:workstation_flutter/home/presentation/home_page.dart';
import '../widgets/base_text_field.dart';
import '../widgets/base_button.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8BC34A),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo with yellow circle background
                  Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8F48C), // Light yellow
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/logo/app_logo.png', 
                        width: 60,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Workstation',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Iniciar Sesion',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  BaseTextField(
                    controller: _emailController,
                    hint: 'Correo electronico',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa tu correo';
                      }
                      if (!value.contains('@')) {
                        return 'Por favor ingresa un correo válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  BaseTextField(
                    controller: _passwordController,
                    hint: 'Contraseña',
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa tu contraseña';
                      }
                      if (value.length < 6) {
                        return 'La contraseña debe tener al menos 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  BaseButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    },
                    icon: Icons.arrow_forward,
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () {
                      // TODO: Navigate to forgot password
                    },
                    child: RichText(
                      text: const TextSpan(
                        text: 'Olvidaste tu ',
                        style: TextStyle(color: Colors.black87, fontSize: 14),
                        children: [
                          TextSpan(
                            text: 'contraseña?',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ),
                      );
                    },
                    child: RichText(
                      text: const TextSpan(
                        text: 'Sino tienes cuenta, ',
                        style: TextStyle(color: Colors.black87, fontSize: 14),
                        children: [
                          TextSpan(
                            text: 'regístrate aquí',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Copyright 2025@ Workstation, PinkCells',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
