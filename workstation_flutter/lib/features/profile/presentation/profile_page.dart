import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:workstation_flutter/features/profile/domain/user.dart';
import 'package:workstation_flutter/core/storage/token_storage.dart';
import 'package:workstation_flutter/features/auth/presentation/pages/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageeState();
}

class _ProfilePageeState extends State<ProfilePage> {
  late User _currentUser;

  @override
  void initState() {
    super.initState();

    _currentUser = User(
      firstName: '',
      lastName: '',
      dni: '',
      phoneNumber: '',
      email: '',
    );
    _loadCurrentUser();
  }


  Future<void> _loadCurrentUser() async {
    try {
      final token = await TokenStorage().read();
      if (token == null || token.isEmpty) return;

      final Map<String, dynamic> claims = JwtDecoder.decode(token);

      final firstName = (claims['given_name'] ?? claims['firstName'] ?? claims['givenName'] ?? (claims['name'] is String ? (claims['name'] as String).split(' ').first : null) ?? '') as String;
      final lastName = (claims['family_name'] ?? claims['lastName'] ?? claims['familyName'] ?? (claims['name'] is String ? (claims['name'] as String).split(' ').skip(1).join(' ') : null) ?? '') as String;
      final email = (claims['email'] ?? claims['Email'] ?? '') as String;
      final dni = (claims['dni'] ?? '') as String;
      final phone = (claims['phone'] ?? claims['phoneNumber'] ?? '') as String;

      setState(() {
        _currentUser = User(
          firstName: firstName.isEmpty ? _currentUser.firstName : firstName,
          lastName: lastName.isEmpty ? _currentUser.lastName : lastName,
          dni: dni.isEmpty ? _currentUser.dni : dni,
          phoneNumber: phone.isEmpty ? _currentUser.phoneNumber : phone,
          email: email.isEmpty ? _currentUser.email : email,
        );
      });
    } catch (e) {
      // If token can't be decoded or claims missing, keep defaults.
      // Consider logging the error in real app.
    }
  }

  void _editField(String fieldName, String currentValue) {
    final controller = TextEditingController(text: currentValue);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar $fieldName'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: fieldName,
              border: const OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  switch (fieldName) {
                    case 'Nombre':
                      _currentUser.firstName = controller.text;
                      break;
                    case 'Apellido':
                      _currentUser.lastName = controller.text;
                      break;
                    case 'DNI':
                      _currentUser.dni = controller.text;
                      break;
                    case 'Teléfono':
                      _currentUser.phoneNumber = controller.text;
                      break;
                    case 'Email':
                      _currentUser.email = controller.text;
                      break;
                  }
                });
                Navigator.pop(context);
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cerrar sesión'),
          content: const Text('¿Deseas cerrar sesión en tu cuenta?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                try {
                  await TokenStorage().delete();

                  // Navigate back to Login and remove all previous routes
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error al cerrar sesión')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF689F38),
              ),
              child: const Text('Cerrar sesión'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    color: Color(0xFF8BC34A),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.elliptical(200, 50),
                        topRight: Radius.elliptical(200, 50),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 80,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD4E99F), 
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 70,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _currentUser.fullName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  children: [
                    _buildEditableField('Nombre', _currentUser.firstName),
                    const SizedBox(height: 12),
                    _buildEditableField('Apellido', _currentUser.lastName),
                    const SizedBox(height: 12),
                    _buildEditableField('DNI', _currentUser.dni),
                    const SizedBox(height: 12),
                    _buildEditableField('Teléfono', _currentUser.phoneNumber),
                    const SizedBox(height: 12),
                    _buildEditableField('Email', _currentUser.email),
                    const SizedBox(height: 32),
                    
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _confirmLogout,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF689F38), 
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: const Text(
                              'Cerrar sesión',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // TODO: Save changes to backend
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Cambios guardados')),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD4E99F), 
                              foregroundColor: Colors.black87,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: const Text(
                              'Editar usuario',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    
  }

  Widget _buildEditableField(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.black54),
            onPressed: () => _editField(label, value),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}