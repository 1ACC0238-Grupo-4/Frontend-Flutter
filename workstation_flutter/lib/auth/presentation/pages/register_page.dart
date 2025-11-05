import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workstation_flutter/auth/presentation/widgets/main_navigator.dart';
import 'package:workstation_flutter/home/presentation/home_page.dart';
import 'package:workstation_flutter/core/enums/status.dart';
import '../widgets/base_text_field.dart';
import '../widgets/base_button.dart';
import '../blocs/register_blocs/register_bloc.dart';
import '../blocs/register_blocs/register_event.dart';
import '../blocs/register_blocs/register_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dniController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _dniController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      context.read<RegisterBloc>().add(Register());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8BC34A),
      body: BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state.status == Status.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Registro exitoso'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
            
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainNavigation()),
            );
          } else if (state.status == Status.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('error xd'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 4),
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state.status == Status.loading;
          
          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE8F48C),
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
                        'Registrate',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      
                      // Selector de Rol
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Selecciona tu rol*',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: isLoading ? null : () {
                                      context.read<RegisterBloc>().add(
                                        const OnRoleChanged(role: 1),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      decoration: BoxDecoration(
                                        color: state.role == 1
                                            ? const Color(0xFF8BC34A)
                                            : Colors.grey[200],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'Buscador',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: state.role == 1
                                              ? Colors.white
                                              : Colors.black54,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: InkWell(
                                    onTap: isLoading ? null : () {
                                      context.read<RegisterBloc>().add(
                                        const OnRoleChanged(role: 2),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      decoration: BoxDecoration(
                                        color: state.role == 2
                                            ? const Color(0xFF8BC34A)
                                            : Colors.grey[200],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'Arrendador',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: state.role == 2
                                              ? Colors.white
                                              : Colors.black54,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      BaseTextField(
                        controller: _nameController,
                        hint: 'Nombre*',
                        enabled: !isLoading,
                        onChanged: (value) {
                          context.read<RegisterBloc>().add(
                            OnFirstNameChanged(firstName: value),
                          );
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu nombre';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      BaseTextField(
                        controller: _lastNameController,
                        hint: 'Apellido*',
                        enabled: !isLoading,
                        onChanged: (value) {
                          context.read<RegisterBloc>().add(
                            OnLastNameChanged(lastName: value),
                          );
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu apellido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      BaseTextField(
                        controller: _dniController,
                        hint: 'DNI*',
                        keyboardType: TextInputType.number,
                        enabled: !isLoading,
                        onChanged: (value) {
                          context.read<RegisterBloc>().add(
                            OnDniChanged(dni: value),
                          );
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu DNI';
                          }
                          if (value.length != 8) {
                            return 'El DNI debe tener 8 dígitos';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      BaseTextField(
                        controller: _emailController,
                        hint: 'Email*',
                        keyboardType: TextInputType.emailAddress,
                        enabled: !isLoading,
                        onChanged: (value) {
                          context.read<RegisterBloc>().add(
                            OnEmailChanged(email: value),
                          );
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu email';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return 'Por favor ingresa un email válido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      BaseTextField(
                        controller: _phoneController,
                        hint: 'Celular*',
                        keyboardType: TextInputType.phone,
                        enabled: !isLoading,
                        onChanged: (value) {
                          context.read<RegisterBloc>().add(
                            OnPhoneNumberChanged(phoneNumber: value),
                          );
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu celular';
                          }
                          if (value.length != 9) {
                            return 'El celular debe tener 9 dígitos';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      BaseTextField(
                        controller: _passwordController,
                        hint: 'Contraseña*',
                        obscureText: true,
                        enabled: !isLoading,
                        onChanged: (value) {
                          context.read<RegisterBloc>().add(
                            OnPasswordChanged(password: value),
                          );
                        },
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
                      const SizedBox(height: 12),
                      BaseTextField(
                        controller: _confirmPasswordController,
                        hint: 'Repita Contraseña*',
                        obscureText: true,
                        enabled: !isLoading,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor confirma tu contraseña';
                          }
                          if (value != _passwordController.text) {
                            return 'Las contraseñas no coinciden';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      
                      if (isLoading)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        )
                      else
                        Row(
                          children: [
                            Expanded(
                              child: BaseButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icons.arrow_back,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: BaseButton(
                                onPressed: _handleRegister,
                                icon: Icons.arrow_forward,
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 32),
                      const Text(
                        'Copyright 2025@ Workstation, PinkCells',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}