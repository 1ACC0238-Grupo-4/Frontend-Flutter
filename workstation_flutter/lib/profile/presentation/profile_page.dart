import 'package:flutter/material.dart';
import 'package:workstation_flutter/chats/presentation/chats_page.dart';
import 'package:workstation_flutter/home/presentation/home_page.dart';
import 'package:workstation_flutter/offices/presentation/offices_page.dart';
import 'package:workstation_flutter/profile/domain/user.dart';
import 'package:workstation_flutter/search/presentation/search_page.dart';
import 'package:workstation_flutter/shared/presentation/widgets/bottom_nav_bar_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageeState();
}

class _ProfilePageeState extends State<ProfilePage> {
  final int _currentIndex = 4;

  // Mock user data
  late User _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = User(
      firstName: 'Rodrigo',
      lastName: 'García',
      dni: '12345678',
      phoneNumber: '+51 987 654 321',
      email: 'rodrigo.garcia@email.com',
    );
  }

  void _onNavTap(int index) {
    if (index == _currentIndex) return;
    
    Widget page;
    switch (index) {
      case 0:
        page = const HomePage();
        break;
      case 1:
        page = const OfficesPage();
        break;
      case 2:
        page = const SearchPage();
        break;
      case 3:
        page = const ChatsPage();
        break;
      case 4:
        return; // Already on this page
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
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

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar usuario'),
          content: const Text('¿Estás seguro que deseas eliminar tu cuenta? Esta acción no se puede deshacer.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement delete user logic
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cuenta eliminada')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with inverted wave decoration
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
                        color: Color(0xFFD4E99F), // Light green
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
            // User name
            Text(
              _currentUser.fullName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            // Editable fields
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
                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _showDeleteDialog,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF689F38), // Dark green
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: const Text(
                              'Eliminar usuario',
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
                              backgroundColor: const Color(0xFFD4E99F), // Light green
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
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
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